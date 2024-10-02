//
//  File.swift
//  SwifTecInventory
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI

// Viewmodel para extraer a nuestros items desde firestore
@Observable
class InventoryListViewModel {
    var items = [InventoryItem]()
    
    @MainActor
    func fetchItems() {
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
