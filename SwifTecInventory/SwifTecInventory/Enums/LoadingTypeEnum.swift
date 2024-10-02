//
//  LoadingTypeEnum.swift
//  SwifTecInventory
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation

enum LoadingType: Equatable {
    case none
    case savingItem
    case uploading(UploadType)
    case deleting(DeleteType)
    
}
