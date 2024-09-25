//
//  InventoryItem.swift
//  SwifTec-Inventory-App
//
//  Created by Sebastian Rosas Maciel on 9/22/24.
//

import Foundation
import FirebaseFirestore

public struct InventoryItem: Identifiable, Codable, Equatable {
    public var id = UUID().uuidString
    
    // Timestamps de subida y actualizacion definidas por el servidor
    @ServerTimestamp
    var createdAt: Date?
    @ServerTimestamp
    var updatedAt: Date?
    
    var name: String
    var quantity: Int
    
    var usdzLink: String?
    
    // Computed variable para convertir a usdzLink   a una URL valida
    var usdzURL: URL? {
        // Revizar que la propiedad de link no sea nula
        guard let usdzLink else { return nil }
        
        return URL(string: usdzLink)
    }
    
    // QuickLook framework. para crear thumbnails de 300 x 300 en base al archivo usdz
    var thumbnailLink: String?
    
    // Computed variable para convertir a thumbnailLink a una URL valida
    var thumbnailURL: URL? {
        guard let thumbnailLink else { return nil }
        
        return URL(string: thumbnailLink)
    }
}
