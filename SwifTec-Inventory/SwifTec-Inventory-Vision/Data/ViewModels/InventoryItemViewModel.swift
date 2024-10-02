//
//  InventoryItemViewModel.swift
//  SwifTec-Inventory-Vision
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import SwiftUI
import RealityKit

@Observable
class InventoryItemViewModel {
    
    var item: InventoryItem?
    var usdzFileURL: URL?
    var entity: ModelEntity?
    
    var onItemDeleted: (() -> Void)? = nil
    
    func listenToItem(_ item: InventoryItem) {
    }
    
    
    @MainActor
    func fetchFileURL(usdzURL: URL) async {
     
}

