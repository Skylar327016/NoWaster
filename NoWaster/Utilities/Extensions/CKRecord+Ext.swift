
import CloudKit

extension CKRecord: Identifiable {
    public var id: ID {
        return self.recordID
    }
    
    func convertToInventoryItem() -> InventoryItem { InventoryItem(record: self)}
    func convertToUser() -> User { User(record: self) }
    func convertToGiver() -> Giver { Giver(record: self) }
}
