
import SwiftUI
import CloudKit
import Firebase

final class AppTabViewModel: ObservableObject {
    
    @Published var showingFirstStartUpView = false
    @Published var showingSignInView = false
    @Published var tabSelection = 1
    @Published var newItemsImported = false
    @Published var recipientUids: [String] = []
    var pushRecipientUid: String?

    
    func startUpCheck() {
        guard let uid = Auth.auth().currentUser?.uid else {
            DispatchQueue.main.async { self.showingFirstStartUpView = true }
            
            return
        }
        
        CloudKitManager.shared.fetchUserRecord(with: uid) { [weak self] record in
            guard let record = record else {
                DispatchQueue.main.async { self?.showingFirstStartUpView = true }
                return
            }
            CloudKitManager.shared.user = record
        }
        
    }
    
    func authCheck() {
        if Auth.auth().currentUser == nil{
            showingSignInView = true
        }
    }
    
    func fetchAllChatRecipients() {
        DatabaseManager.shared.fetchAllChats { [weak self] recipientUids in
            guard let recipientUids = recipientUids, let self = self else {
                return
            }
            self.recipientUids = recipientUids
        }
    }
    
    
    func title() -> String {
        switch tabSelection {
            case 1:
                return "Shopping List"
            case 4:
                return "Chat"
            case 5:
                return "Profile"
            default:
                return ""
        }
    }
}
