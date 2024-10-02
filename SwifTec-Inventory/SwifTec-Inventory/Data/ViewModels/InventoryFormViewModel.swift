//
//  InventoryFormViewModel.swift
//  SwifTec-Inventory
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation

import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import QuickLookThumbnailing

@Observable
class InventoryFormViewModel {
    
    let db = Firestore.firestore()
    let formType: FormType
    
    let id: String
    var name = ""
    var quantity = 0
    var usdzURL: URL?
    var thumbnailURL: URL?
    
    var loadingState = LoadingType.none
    var error: String?
    
    var uploadProgress: UploadProgress?
    var showUSDZSource = false
    var selectedUSDZSource: USDZSourceType?
    
    let byteCountFormatter: ByteCountFormatter = {
        let f = ByteCountFormatter()
        f.countStyle = .file
        return f
    }()
    
    var navigationTitle: String {
        switch formType {
        case .add:
            return "Add Item"
        case .edit:
            return "Edit Item"
        }
    }
    
    init(formType: FormType = .add) {
        self.formType = formType
        switch formType {
        case .add:
            id = UUID().uuidString
        case .edit(let item):
            id = item.id
            name = item.name
            quantity = item.quantity
            if let usdzURL = item.usdzURL {
                self.usdzURL = usdzURL
            }
            if let thumbnailURL = item.thumbnailURL {
                self.thumbnailURL = thumbnailURL
            }
        }
    }
    
    func save() throws {
        loadingState = .savingItem
        
        defer { loadingState = .none }
        
        var item: InventoryItem
        switch formType {
        case .add:
            item = .init(id: id, name: name, quantity: quantity)
        case .edit(let inventoryItem):
            item = inventoryItem
            item.name = name
            item.quantity = quantity
        }
        item.usdzLink = usdzURL?.absoluteString
        item.thumbnailLink = thumbnailURL?.absoluteString
        
        do {
            try db.document("items/\(item.id)")
                .setData(from: item)
        } catch {
            self.error = error.localizedDescription
            throw error
        }
    }
    
    @MainActor
    func deleteUSDZ() async {
        let storageRef = Storage.storage().reference()
        let usdzRef = storageRef.child("\(id).usdz")
        let thumbnailRef = storageRef.child("\(id).jpg")
        
        loadingState = .deleting(.usdzWithThumbnail)
        defer { loadingState = .none }
        
        do {
            try await usdzRef.delete()
            try? await thumbnailRef.delete()
            self.usdzURL = nil
            self.thumbnailURL = nil
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    @MainActor
    func deleteItem() async throws {
        loadingState = .deleting(.item)
        do {
            try await db.document("items/\(id)").delete()
            try? await Storage.storage().reference().child("\(id).usdz").delete()
            try? await Storage.storage().reference().child("\(id).jpg").delete()
        } catch {
            loadingState = .none
            throw error
        }
    }
    
    @MainActor
    func uploadUSDZ(fileURL: URL, isSecurityScopedResource: Bool = false) async {
        if isSecurityScopedResource, !fileURL.startAccessingSecurityScopedResource() {
            return
        }
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if isSecurityScopedResource {
            fileURL.stopAccessingSecurityScopedResource()
        }
        uploadProgress = .init(fractionCompleted: 0, totalUnitCount: 0, completedUnitCount: 0)
        loadingState = .uploading(.usdz)
        
        defer { loadingState = .none }
        do {
            /// Upload USDZ to Firebase Storage
            let storageRef = Storage.storage().reference()
            let usdzRef = storageRef.child("\(id).usdz")
            
            _ = try await usdzRef.putDataAsync(data, metadata: .init(dictionary: ["contentType": "model/vnd.usd+zip"])) { [weak self] progress in
                guard let self, let progress else { return }
                self.uploadProgress = .init(fractionCompleted: progress.fractionCompleted, totalUnitCount: progress.totalUnitCount, completedUnitCount: progress.completedUnitCount)
            }
            let downloadURL = try await usdzRef.downloadURL()
            
            /// Generate Thumbnail
            let cacheDirURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let fileCacheURL = cacheDirURL.appending(path: "temp_\(id).usdz")
            try? data.write(to: fileCacheURL)
            
            let thumbnailRequest = QLThumbnailGenerator.Request(fileAt: fileCacheURL, size: .init(width: 300, height: 300), scale: UIScreen.main.scale, representationTypes: .all)
            
            if let thumbnail = try? await QLThumbnailGenerator.shared.generateBestRepresentation(for: thumbnailRequest),
               let jpgData = thumbnail.uiImage.jpegData(compressionQuality: 0.5) {
                loadingState = .uploading(.thumbnail)
                let thumbnailRef = storageRef.child("\(id).jpg")
                _ = try? await thumbnailRef.putDataAsync(jpgData, metadata: .init(dictionary: ["contentType": "image/jpeg"]), onProgress: { [weak self] progress in
                    guard let self, let progress else { return }
                    self.uploadProgress = .init(fractionCompleted: progress.fractionCompleted, totalUnitCount: progress.totalUnitCount, completedUnitCount: progress.completedUnitCount)
                })
                
                if let thumbnailURL = try? await thumbnailRef.downloadURL() {
                    self.thumbnailURL = thumbnailURL
                }
            }
            
            self.usdzURL = downloadURL
        } catch {
            self.error = error.localizedDescription
        }
    }
}


