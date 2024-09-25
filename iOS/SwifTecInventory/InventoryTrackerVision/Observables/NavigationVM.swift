//
//  NavigationVM.swift
//  InventoryTrackerVision
//
//  Created by Eugenio Pedraza on 9/21/24.
//

import Foundation
import SwiftUI

class NavigationViewModel: ObservableObject {
    
    @Published var selectedItem: InventoryItem?
    
    init(selectedItem: InventoryItem? = nil) {
        self.selectedItem = selectedItem
    }
    
    
}
