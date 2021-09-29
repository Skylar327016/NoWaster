

import SwiftUI

struct NewMessageView: View {
    
    @StateObject var viewModel = MessageViewModel()
    
    let recipientUid: String
    
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarTitle(Text(viewModel.recipient?.username ?? "" ))
        .onAppear(perform: fetchRecipientInfo)
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
    
    
    private func fetchRecipientInfo() {
        viewModel.isNewChat = true
        viewModel.getRecipientInfo(with: recipientUid)
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView(recipientUid: "123")
    }
}
