
import Firebase
import SwiftUI

final class ChatViewModel: ObservableObject {
    
    @Published var chats: [Chat] = []
    
    var didLoad = false
    
    
    func startListeningForChat() {
        
        if didLoad { return }
        
        guard let record = CloudKitManager.shared.user else { return }
        let uid = User(record: record).uid
        DatabaseManager.shared.getAllChats(for: uid) { [weak self] chats in
            guard let chats = chats, !chats.isEmpty else { return }
            DispatchQueue.main.async {
                self?.chats = chats
            }
        }
        didLoad = true
    }
}


