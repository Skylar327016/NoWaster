
import Foundation

struct Chat: Identifiable {
    let id: String
    let otherUid: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}
