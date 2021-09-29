
import SwiftUI

struct MessageCell: View {
    let message: Message
    var isSenderself: Bool
    
    var body: some View {
        HStack(alignment: .top){
            
            if isSenderself { Spacer() }

            Text(messageContent())
                .frame(alignment: isSenderself ? .leading : .trailing)
                .padding(.top, 5)
                .padding(.bottom, 5)
                .padding(.trailing, 10)
                .padding(.leading, 10)
                .background(isSenderself ? Color.brandPrimary : Color.brandSecondary)
                .foregroundColor(.white)
                .cornerRadius(15)
            
            if !isSenderself { Spacer() }
        }
        .padding(.leading, isSenderself ? 30 : 10)
        .padding(.trailing, isSenderself ? 10 : 30)
        .padding(.top, 2)
    }
    
    func messageContent() -> String {
        switch message.type {
        case .text(let messageText):
            return messageText
        case .image(_):
            return ""
        }
    }
}

struct SenderCell_Previews: PreviewProvider {
    static var previews: some View {
        MessageCell(message: MockData.message4, isSenderself: true)
    }
}
