import SwiftUI

struct LocationAddressCell: View {
    
    let mapItem: MapItem
    
    var body: some View {
        HStack{
            Image(systemName: "mappin.and.ellipse")
                .resizable()
                .frame(width: 20, height: 20)
                .padding()
            
            VStack(alignment: .leading, spacing: 5) {
                Text(mapItem.name)
                    .font(.system(size: 16))
                
                Text(mapItem.address)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}
