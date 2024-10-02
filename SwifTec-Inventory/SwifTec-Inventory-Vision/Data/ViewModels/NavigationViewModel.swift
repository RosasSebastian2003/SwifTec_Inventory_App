//
//  NavigationViewModel.swift
//  SwifTec-Inventory-Vision
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation
import SwiftUI

@Observable
class NavigationViewModel {
    
    var selectedItem: InventoryItem?
    
    init(selectedItem: InventoryItem? = nil) {
        self.selectedItem = selectedItem
    }
}
