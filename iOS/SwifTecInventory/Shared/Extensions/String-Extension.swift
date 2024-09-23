//
//  String-Extension.swift
//  SwifTec-Inventory-App
//
//  Created by Sebastian Rosas Maciel on 9/22/24.
//

import Foundation

extension String: Error, LocalizedError {
    
    public var errorDescription: String? { self }
}
