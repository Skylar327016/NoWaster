

import SwiftUI
import CloudKit

struct InventoryListCell: View {
    
    let record: CKRecord
    var item: InventoryItem {
        InventoryItem(record: record)
    }
    @ObservedObject var viewModel: InventoryListViewModel
    
    var body: some View {
        ZStack {
            HStack {
                ImageHolder(diameter: 90, image: Image(uiImage: item.image?.convertToUIImage() ?? .foodPlaceholder))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .frame(height: 50)
                    Text(Date().expire(in: item.expiry))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .frame(height: 90)
            .overlay(checkmarkButton(), alignment: .bottomTrailing)
        }
    }
    
    
    @ViewBuilder func checkmarkButton() -> some View {
        Image(systemName: "checkmark.circle")
            .frame(width: 44, height: 44)
            .imageScale(.large)
            .foregroundColor(viewModel.selected(record) ? .brandPrimary : Color(.systemGray))
            .onTapGesture {
                if viewModel.selected(record) {
                    viewModel.deselect(record)
                } else {
                    viewModel.select(record)
                }
            }
    }
    
}

struct InventoryListCell_Previews: PreviewProvider {
    static var previews: some View {
        InventoryListCell(record: MockData.inventoryItem, viewModel: InventoryListViewModel())
    }
}
