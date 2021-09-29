
import SwiftUI

struct ChatCell: View {
    
    @StateObject var viewModel = ChatCellModel()
    let chat: Chat
    
    var body: some View {
        HStack(spacing: 10) {
            ImageHolder(diameter: 60, image: Image(uiImage: viewModel.recipient?.avatar?.convertToUIImage() ?? .man))
            
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text(viewModel.recipient?.username ?? "")
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                    
                    Text(viewModel.showDisplayDate(with: chat.latestMessage.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(chat.latestMessage.text)
                    .frame(maxWidth: 180, maxHeight: 33, alignment: .leading)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear(perform: { viewModel.getRecipientInfo(with: chat.otherUid) })
    }
}

struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(chat: MockData.chat1)
    }
}
