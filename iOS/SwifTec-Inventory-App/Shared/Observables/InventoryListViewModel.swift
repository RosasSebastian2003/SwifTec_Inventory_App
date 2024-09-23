//
//  InventoryListViewModel.swift
//  SwifTec-Inventory-App
//
//  Created by Sebastian Rosas Maciel on 9/22/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

// Viewmodel para extraer a nuestros items desde firestore
class InventoryListViewModel: Observable {
    var items = [InventoryItem]()
    
    @MainActor
    func listenToItems() {
        Firestore.firestore().collection("items")
            .order(by: "name")
            .limit(toLast: 100)
            .addSnapshotListener { snapshot, error in
                guard let snapshot else {
                    print("Failed fetching snapshot with error: \(error?.localizedDescription ?? "error")")
                    
                    return
                }
                
                let docs = snapshot.documents
                
                // Mapeamos a los items obtenidos a objetos de tipo InventoryItem
                let items = docs.compactMap {
                    try? $0.data(as: InventoryItem.self)
                }
                
                withAnimation {
                    self.items = items
                }
            }
    }
}
