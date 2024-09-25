//
//  SwifTecInventoryApp.swift
//  SwifTecInventory
//
//  Created by Sebastian Rosas Maciel on 9/22/24.
//

import SwiftUI

@main
struct SwifTecInventoryApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                InventoryListView()
            }
        }
    }
}
