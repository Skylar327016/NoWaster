
import SwiftUI
import CloudKit

struct GiverInfoCell: View {
    
    let record: CKRecord
    var gift: InventoryItem { InventoryItem(record: record) }
    
    @ObservedObject var giverInfoViewModel: GiverInfoViewModel
    
    var body: some View {
        ZStack {
            HStack{
                ImageHolder(diameter: 80, image: Image(uiImage: gift.image?.convertToUIImage() ?? .foodPlaceholder))
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(gift.name)
                        .font(.body)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .frame(maxWidth: 150, maxHeight: 50, alignment: .leading)
                    Text(Date().expire(in: gift.expiry))
                        .font(.caption)
                        .foregroundColor((.secondary))
                    Spacer()
                }
                Spacer()
            }
            .padding()
            .frame(height: 90)
            .overlay(
                requestButton()
                ,alignment: .trailing
            )
            
        }
    }
    
    
    @ViewBuilder private func requestButton() -> some View {
        Text(giverInfoViewModel.userIsSelf ? "Retrieve" : "Request")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 80, height: 25)
            .background(Color.brandSecondary)
            .cornerRadius(18)
            .onTapGesture {
                if giverInfoViewModel.userIsSelf {
                    giverInfoViewModel.retrieveGift(record: record)
                } else {
//                    giverInfoViewModel.requestGift(record: record)
                }
            }
    }
}

struct GiverInfoCell_Previews: PreviewProvider {
    static var previews: some View {
        GiverInfoCell(record: MockData.inventoryItem, giverInfoViewModel: GiverInfoViewModel())
    }
}
