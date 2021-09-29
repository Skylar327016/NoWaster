
import CloudKit

struct Giver: Identifiable {
    
    static let kLocation = "location"
    static let kUser = "user"
    
    let id: CKRecord.ID
    let location: CLLocation
    let user: CKRecord.Reference?
    
    init(record: CKRecord) {
        id = record.recordID
        location = record[Giver.kLocation] as? CLLocation ?? CLLocation(latitude: 0, longitude: 0)
        user = record[Giver.kUser] as? CKRecord.Reference
    }
}
