//
//  InventoryListView.swift
//  SwifTec-Inventory-App
//
//  Created by Sebastian Rosas Maciel on 9/22/24.
//

import SwiftUI

struct InventoryListView: View {
    @State var viewModel = InventoryListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.items) { item in
                Text(item.name)
            }
        }
        .navigationTitle("AR Inventory")
        .onAppear{
            viewModel.fetchItems()
        }
    }
}

#Preview {
    InventoryListView()
}
