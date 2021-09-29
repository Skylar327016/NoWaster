
import CloudKit
import UIKit

struct InventoryItem: Identifiable{
    
    static let kName = "name"
    static let kImage = "image"
    static let kExpiry = "expiry"
    static let kIsGift = "isGift"
    static let kUser = "user"
    
    let id: CKRecord.ID
    let user: CKRecord.Reference?
    var name: String
    var expiry: Date
    var isGift: Int
    var image: CKAsset?
    
    
    
    init(record: CKRecord) {
        id = record.recordID
        name = record[InventoryItem.kName] as? String ?? "N/A"
        image = record[InventoryItem.kImage] as? CKAsset
        expiry = record[InventoryItem.kExpiry] as? Date ?? Date()
        isGift = record[InventoryItem.kIsGift] as? Int ?? 0
        user = record[InventoryItem.kUser] as? CKRecord.Reference
    }
}
