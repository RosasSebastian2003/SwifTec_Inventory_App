//
//  SwifTec_Inventory_VisionApp.swift
//  SwifTec-Inventory-Vision
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import SwiftUI

@main
struct SwifTec_Inventory_VisionApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var navVM = NavigationViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                InventoryListView()
                    .environmentObject(navVM)
            }
        }
        WindowGroup(id: "item") {
            InventoryItemView()
                .environmentObject(navVM)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
    }
}
