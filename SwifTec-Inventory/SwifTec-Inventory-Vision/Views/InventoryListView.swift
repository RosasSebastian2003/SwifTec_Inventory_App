//
//  InventoryListView.swift
//  SwifTec-Inventory-Vision
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import SwiftUI
import RealityKit

struct InventoryListView: View {
    
    @State var vm = InventoryListViewModel()
    private let gridItems: [GridItem] =
    [.init(.adaptive(minimum: 240), spacing: 16)]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: gridItems) {
                ForEach(vm.items) { item in
                    InventoryTrackerItemView(item: item)
                        .onDrag {
                            guard let usdzURL = item.usdzURL else { return NSItemProvider() }
                            return NSItemProvider(object: USDZItemProvider(usdzURL: usdzURL))
                        }
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 30)
        }
        .navigationTitle("AR Inventory")
        .onAppear { vm.fetchItems() }
    }
}

#Preview {
    
    @StateObject var navVM = NavigationViewModel()
    
    return NavigationStack {
        InventoryListView()
            .environmentObject(navVM)
    }
}
