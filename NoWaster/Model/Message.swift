
import UIKit

struct Message: Identifiable {
    let sender: String
    let id: String
    let sentDate: Date
    let type: MessageType
}

enum MessageType {
    case text(String)
    case image(UIImage)
}

extension MessageType {
    var description: String {
        switch self {
        case .text(_):
            return "text"
        case .image(_):
            return "image"
        }
    }
}
