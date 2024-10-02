//
//  AppDelegate.swift
//  SwifTec-Inventory
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation
import FirebaseStorage
import FirebaseCore
import FirebaseFirestore
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // Use local emmulator instead
        setupFirebaseLocalEmulator()
        
        return true
    }
    
    func setupFirebaseLocalEmulator() {
        var host = "127.0.0.1"
        
        #if !targetEnvironment(simulator)
        host = "192.168.100.138"
        #endif
        
        let settings = Firestore.firestore().settings
        settings.host = "\(host):8080"
        settings.cacheSettings = MemoryCacheSettings()
        settings.isSSLEnabled = false
        
        Firestore.firestore().settings = settings
        
        Storage.storage().useEmulator(withHost: host, port: 9199)
    }
}
