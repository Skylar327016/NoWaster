
import SwiftUI
import Firebase
import CloudKit

final class MessageViewModel: ObservableObject {
    
    @Published var text = ""
    @Published var messages: [Message] = []
    @Published var recipient: User?
    var isNewChat = false
    var didLoad = false
    var chat: Chat?
    
    func checkIfSenderIsSelf(uid: String) -> Bool {
        return uid == Auth.auth().currentUser?.uid
    }
    
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    
    func getRecipientInfo(with uid: String) {
        CloudKitManager.shared.fetchUserRecord(with: uid) { [weak self] record in
            guard let record = record else { return }
            DispatchQueue.main.async {
                self?.recipient = User(record: record)
            }
        }
    }
    
    func send() {
        guard let uid = Auth.auth().currentUser?.uid, let recipient = recipient else { return }
        let id = createMessageId(with: uid, and: recipient.uid)
        let message = Message(sender: uid, id: id, sentDate: Date(), type: .text(text))
        
        DispatchQueue.main.async { [weak self] in
            self?.text = ""
        }
        
        if isNewChat {
            DatabaseManager.shared.createNewChat(with: recipient.uid, firstMessage: message) { [weak self] chat in
                if let chat = chat {
                    self?.isNewChat = false
                    self?.startListeningForMessage(with: chat.id)
                    self?.chat = chat
                } else {
                    print("failed to send message")
                }
            }
        } else {
            guard let chat = chat else { return }
            DatabaseManager.shared.sendMessage(to: chat.id, message: message) { success in
                
            }
        }
    }
    
    
    func startListeningForMessage(with id: String) {
        if didLoad { return }
        DatabaseManager.shared.getAllMessagesForChat(with: id) { [weak self] messages in
            guard let messages = messages, !messages.isEmpty else { return }
            DispatchQueue.main.async {
                self?.messages = messages
            }
        }
        didLoad = true
    }
    
    
    private func createMessageId(with uid: String, and otherUid: String) -> String{
        let dateString = Self.dateFormatter.string(from: Date())
        return "\(uid)_\(dateString)_\(otherUid)"
    }
    
    
    
}
