
import SwiftUI

final class ChatCellModel: ObservableObject {
    
    @Published var recipient: User?
    var didLoad = false
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    func showDisplayDate(with dateString: String) -> String {
        guard let date = MessageViewModel.dateFormatter.date(from: dateString) else { return "" }
        return Self.dateFormatter.string(from: date)
    }
    
    func getRecipientInfo(with uid: String) {
        if didLoad { return }
        CloudKitManager.shared.fetchUserRecord(with: uid) { [weak self] record in
            guard let record = record else {
                return
            }
            DispatchQueue.main.async {
                self?.recipient = User(record: record)
                self?.didLoad = true
            }
        }
    }
}
