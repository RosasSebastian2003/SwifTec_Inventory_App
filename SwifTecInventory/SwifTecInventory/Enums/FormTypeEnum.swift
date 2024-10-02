//
//  FormTypeEnum.swift
//  SwifTecInventory
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation

enum FormType: Identifiable {
    case add
    case edit(InventoryItem)
    
    var id: String {
        switch self {
        case .add:
            return "add"
        case .edit(let inventoryItem):
            return "edit-\(inventoryItem.id)"
        }
    }
    
}

enum USDZSourceType {
    case fileImporter
    case objectCapture
}

enum UploadType: Equatable {
    case usdz
    case thumbnail
}

enum DeleteType {
    case usdzWithThumbnail
    case item
}


