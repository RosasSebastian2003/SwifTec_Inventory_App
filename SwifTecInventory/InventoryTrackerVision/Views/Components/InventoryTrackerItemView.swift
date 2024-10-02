//
//  InventoryTrackerItemView.swift
//  InventoryTrackerVision
//
//  Created by Sebastian Rosas Maciel on 02/10/24.
//

import Foundation

struct InventoryTrackerItemView: View {
    
    let item: InventoryItem
    
    @EnvironmentObject var navVM: NavigationViewModel
    @Environment(\.openWindow) var openWindow
    
    
    var body: some View {
        Button {
            navVM.selectedItem = item
            openWindow(id: "item")
        } label: {
            VStack {
                ZStack {
                    if let usdzURL = item.usdzURL {
                        Model3D(url: usdzURL) { phase in
                            switch phase {
                            case .success(let model):
                                model.resizable()
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Text("Failed to download 3D Model")
                                
                            default: ProgressView()
                            }
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(Color.gray
                                .opacity(0.3))
                        Text("Not Available")
                    }
                }
                .frame(width: 160, height: 160)
                .padding(.bottom, 32)
                
                Text(item.name)
                Text("Qantity:  \(item.quantity)")
            }
            .frame(width: 240, height: 240)
            .padding(32)
        }
        .buttonStyle(.borderless)
        .buttonBorderShape(.roundedRectangle(radius: 20))
    }
}
