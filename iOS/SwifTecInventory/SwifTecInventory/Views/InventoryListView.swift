//
//  InventoryListView.swift
//  SwifTec-Inventory-App
//
//  Created by Sebastian Rosas Maciel on 9/22/24.
//

import SwiftUI

struct InventoryListView: View {
    
    @State var vm = InventoryListViewModel()
    @State var formType: FormType?
    
    var body: some View {
        List {
            ForEach(vm.items) { item in
                InventoryListItemView(item: item)
                    .listRowSeparator(.hidden)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        formType = .edit(item)
                    }
            }
        }
        .navigationTitle("XCA AR Inventory")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("+ Item") {
                    formType = .add
                }
            }
        }
        .sheet(item: $formType) { type in
            NavigationStack {
                InventoryFormView(vm: .init(formType: type))
            }
            .presentationDetents([.fraction(0.85)])
            .interactiveDismissDisabled()
        }
        .onAppear {
            vm.fetchItems()
        }
    }
}

#Preview {
    NavigationStack {
        InventoryListView()
    }
}
