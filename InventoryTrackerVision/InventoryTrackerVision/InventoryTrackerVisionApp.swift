//
//  InventoryTrackerVisionApp.swift
//  InventoryTrackerVision
//
//  Created by Eugenio Pedraza on 9/21/24.
//

import SwiftUI

@main
struct InventoryTrackerVisionApp: App {
    
    @UIApplicationDelegateAdaptor(AppleDelegate.self) var delegate
    @StateObject var navVM = NavigationViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                InventoryListView()
                    .environmentObject(navVM)
            }
        }
        WindowGroup(id: "item") {
            InventoryItemView().environmentObject(navVM)
        }
        .windowStyle(.volumetric)
        .defaultSize(width: 1, height: 1, depth: 1, in: .meters)
    }
}
