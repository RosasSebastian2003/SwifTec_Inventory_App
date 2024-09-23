//
//  SwifTec_Inventory_AppApp.swift
//  SwifTec-Inventory-App
//
//  Created by Sebastian Rosas Maciel on 9/22/24.
//

import SwiftUI
import FirebaseCore

@main
struct SwifTec_Inventory_App: App {
    // Register app delegate for firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
