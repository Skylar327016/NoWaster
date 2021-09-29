
import CloudKit

struct User: Identifiable {
    static let kUid = "uid"
    static let kUsername = "username"
    static let kAvatar = "avatar"
    static let kBio = "bio"
    static let kGiftLocation = "giftLocation"
    
    let id: CKRecord.ID
    let uid: String
    let username: String
    let avatar: CKAsset?
    let bio: String
    let giftLocation: CLLocation?
    
    init(record: CKRecord) {
        id = record.recordID
        uid = record[User.kUid] as? String ?? "N/A"
        username = record[User.kUsername] as? String ?? "N/A"
        avatar = record[User.kAvatar] as?  CKAsset
        bio = record[User.kBio] as? String ?? "N/A"
        giftLocation = record[User.kGiftLocation] as? CLLocation
    }
}
