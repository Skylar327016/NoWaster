

import SwiftUI

struct MessageView: View {
    
    @StateObject var viewModel = MessageViewModel()
    var chat: Chat
    
    
    var body: some View {
        VStack {
            ScrollView {
                ScrollViewReader { value in
                    ForEach(viewModel.messages) { message in
                        MessageCell(message: message, isSenderself: viewModel.checkIfSenderIsSelf(uid: message.sender))
                    }
                }
            }
            textEntryBox()
        }
        .onAppear(perform: fetchMessagesAndRecipient)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(Text(viewModel.recipient?.username ?? "" ))
    }
    
    
    @ViewBuilder private func textEntryBox() -> some View {
        HStack {
            TextField("Aa", text: $viewModel.text)
                .frame(height: 40)
                .padding(.leading, 15)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color(.gray)))
                .background(Color.white)
            
            Button {
                viewModel.send()
            } label: {
                Image(systemName: viewModel.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "paperplane" : "paperplane.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
        .padding(.leading, 5)
        .padding(.trailing, 10)
    }
    
    
    
    private func fetchMessagesAndRecipient() {
        viewModel.chat = chat
        viewModel.startListeningForMessage(with: chat.id)
        viewModel.getRecipientInfo(with: chat.otherUid)

    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(chat: MockData.chat1)
    }
}
