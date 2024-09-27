//
//  Sample VM.swift
//  SwifTecInventory
//
//  Created by Eugenio Pedraza on 9/25/24.
//

import Foundation
import FirebaseFirestore
import SwiftUI
import QuickLookThumbnailing

@Observable
class SampleVM: ObservableObject {
    let db = Firestore.firestore()
    let formType: FormType
    
    let id: String
    var name: String
    var quantity: Int = 0
    var thumbnailURL: URL?
    
    var loadingState: LoadingType = .none
    var error: Error?
    
    var uploadingState: LoadingType = .none
    var showUSDZSource: Bool = false
    
    
}


