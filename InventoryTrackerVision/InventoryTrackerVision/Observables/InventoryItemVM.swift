//
//  InventoryItemVM.swift
//  InventoryTrackerVision
//
//  Created by Eugenio Pedraza on 9/21/24.
//


// SEGUN EN EL VIDEO DEBE SER "import FirebaseFirestore" TIEMPO 2:17:00
import FirebaseFirestoreCombineSwift
import FirebaseStorage
import Foundation
import SwiftUI
import RealityKit

class InventoryItemViewModel: ObservableObject {
    
    @Published var item: InventoryItem?
    @Published var usdzFileURL: URL?
    @Published var entity: ModelEntity?
    
    var onItemDeleted: (() -> Void)? = nil
    
    func listenToItem(_ item: InventoryItem) {
        self.item = item
        
        /* AQUI DEBERIA SEGUN EL VIDEO TIEMPO 2:19:00 APROX
         Firestore.firestore().collection("items")
            .document(item.id)
            .addSnapshotListener { [weak self] snapshot, error in
         guard let self, let snapshot else {
             print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
             return
         }
         */
        
        // SI LO OTRO LO ARREGLAS FUNCIONA BORRA ESTA PARTE SOLO ESTABA PROBABNDO
        FirebaseFirestoreCombineSwift
        // HASTA AQUI
            .firestore().collection("items")
            .document(item.id)
            .addSnapShotListener { [weak self] snapshot, error in
                guard let self, let snapshot else {
                    print("Error fetching snapshot: \(error?.localizedDescription ?? "error")")
                    return
                }
                
                if !snapshot.exists {
                    self.onItemDeleted?()
                    return
                }
                
                self.item = try? snapshot.data(as: InventoryItem.self)
                if let usdzURL = item.usdzURL {
                    Task { await self.fetchFileURL(usdzURL: usdzURL) }
                } else {
                    self.entity = nil
                    self.usdzFileURL = nil
                }
            }
    }
    
    @MainActor
    func fetchFileURL(usdzURL: URL) async {
        guard let url = usdzURL.usdzFileCacheURL else { return }
        if let usdzFileURL, usdzFileURL.lastPathComponent == usdzURL.lastPathComponent {
            return
        }
        do {
            if !FileManager.default.fileExists(atPath: url.absoluteString) {
                _ = try await Storage.storage().reference(forURL: usdzURL.absoluteString)
                    .writeAsync(toFile: url)
            }
            let entity = try await ModelEntity(contentsOf: url)
            entity.name = item?.usdzURL.absoluteString ?? ""
            entity.generateCollisionShapes(recursive: true)
            entity.components.set(InputTargetComponent())
            self.usdzFileURL = url
            self.entity = entity
            
        } catch {
            self.usdzFileURL = nil
            self.entity = nil
        }
    }
}
