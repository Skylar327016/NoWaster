import Foundation

struct ShoppingListItem: Identifiable, Codable {
    var id = UUID()
    var itemName: String
}

struct ShoppingListHistory: Identifiable, Codable, Comparable {
    static func < (lhs: ShoppingListHistory, rhs: ShoppingListHistory) -> Bool {
        lhs.count < rhs.count
    }
    
    var id = UUID()
    var itemName: String
    var count: Int = 0
}
