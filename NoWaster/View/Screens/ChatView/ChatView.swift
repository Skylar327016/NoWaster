
import SwiftUI


struct ChatView: View {
    
    @StateObject var viewModel = ChatViewModel()
    @EnvironmentObject var tabViewModel: AppTabViewModel
    @State var selection: String?
    
    
    var body: some View {
        ZStack {
            if let recipientUid = tabViewModel.pushRecipientUid {
                if tabViewModel.recipientUids.isEmpty || !tabViewModel.recipientUids.contains(recipientUid){
                    NavigationLink(destination: NewMessageView(recipientUid: recipientUid), tag: recipientUid, selection: $selection) {
                        EmptyView()
                    }
                }
            }
            
            List(viewModel.chats){ chat in
                chatNavigationCell(chat: chat)
            }
            .listStyle(PlainListStyle())
            
            if viewModel.chats.isEmpty {
                EmptyChatState()
            }
            
        }
        .onAppear(perform: viewModel.startListeningForChat)
        .onAppear(perform: checkPushingChat)
        .onDisappear(){tabViewModel.pushRecipientUid = nil }
    }

    
    
    @ViewBuilder private func chatNavigationCell(chat: Chat) -> some View {
        ZStack {
            NavigationLink(destination: MessageView(chat: chat), tag: chat.otherUid, selection: $selection) {
                EmptyView()
            }
            .opacity(0)
            ChatCell(chat: chat)
                .onTapGesture { DispatchQueue.main.async { selection = chat.otherUid } }
        }
    }
    
    private func checkPushingChat() {
        if let recipientUid = tabViewModel.pushRecipientUid{
            selection = recipientUid
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
                .navigationTitle("Chat")
        }
    }
}

