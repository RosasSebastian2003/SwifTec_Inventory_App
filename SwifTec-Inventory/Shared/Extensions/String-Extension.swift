//
//  String-Extension.swift
//  SwifTec-Inventory
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation

extension String: Error, LocalizedError {
    public var errorDescription: String? { self }
}
