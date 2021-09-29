import CloudKit
import UIKit

struct MockData {
    static var inventoryItem: CKRecord {
        let record = CKRecord(recordType: RecordType.inventoryItem)
        
        record[InventoryItem.kName] = "Apple pie Apple pie Apple pie Apple pie Apple pie Apple pie Apple pie"
        record[InventoryItem.kImage] = UIImage.man.convertToCKAsset(with: record.recordID.recordName)
        record[InventoryItem.kExpiry] = Date()
        return record
    }
    
    
    static let inventoryList = Array.init(repeating: InventoryItem(record: inventoryItem), count: 3)
    
    
    static var givers: [CKRecord] {
        let pureGym = CKRecord(recordType: RecordType.giver)
        pureGym[Giver.kLocation] = CLLocation(latitude: 51.732994, longitude: -1.219084)
        
        let feelFit = CKRecord(recordType: RecordType.giver)
        feelFit[Giver.kLocation] = CLLocation(latitude: 51.732763, longitude: -1.216286)
        
        let coop = CKRecord(recordType: RecordType.giver)
        coop[Giver.kLocation] = CLLocation(latitude: 51.729429, longitude: -1.225451)
        
        return [pureGym, feelFit, coop]
    }
    
    
    static var gifter: CKRecord {
        let coop = CKRecord(recordType: RecordType.giver)
        coop[Giver.kLocation] = CLLocation(latitude: 51.729429, longitude: -1.225451)
        return coop
    }
    
    static let chat1 = Chat(id: "1", otherUid: "apa6164790", latestMessage: LatestMessage(date: "1/10/2021", text: "Hi, This is fun. Would you like a cup of tea?", isRead: false))
    
    static let chat2 = Chat(id: "2", otherUid: "apa6164790", latestMessage: LatestMessage(date: "29/10/2021", text: "Hi", isRead: false))
    
    static let chat3 = Chat(id: "3", otherUid: "apa6164790", latestMessage: LatestMessage(date: "1/9/2021", text: "Hi, This is no fun", isRead: false))
    
    static let chat4 = Chat(id: "4", otherUid: "apa6164790", latestMessage: LatestMessage(date: "1/10/2021", text: "Hi, This is fun. Would you like a cup of tea? Or do you prefer coffee rather? Please let me know", isRead: false))
    static let chat5 = Chat(id: "501", otherUid: "apa6143171", latestMessage: LatestMessage(date: "1/10/2021", text: "Hi, This is fun. Would you like a cup of tea? Or do you prefer coffee rather? Please let me know", isRead: false))
    
    static let chats = [chat1, chat2, chat3, chat4]
    
    static var manyChats: [Chat]  {
        var chats: [Chat] = []
        for i in 0...500 {
            chats.append(Chat(id: "\(i)", otherUid: "apa6143171", latestMessage: LatestMessage(date: "1/9/2021", text: "Hi, This is no fun", isRead: false)))
        }
        chats.append(chat5)
        return chats
    }
    
    static let message1 = Message(sender: User(record: CloudKitManager.shared.user!).uid, id: UUID().uuidString, sentDate: Date(), type: .text("Hi") )
    
    static let message2 = Message(sender: User(record: CloudKitManager.shared.user!).uid, id: UUID().uuidString, sentDate: Date(), type: .text("What's up") )
    
    static let message3 = Message(sender: "1", id: UUID().uuidString, sentDate: Date(), type: .text("Hi") )
    
    static let message4 = Message(sender: User(record: CloudKitManager.shared.user!).uid, id: UUID().uuidString, sentDate: Date(), type: .text("Teton County Coroner Dr Brent Blue confirmed the remains are those of Gabrielle Venora Petito, date of birth March 19, 1999. Coroner Blue's initial determination for the manner of death is homicide") )
    static let message5 = Message(sender: "1", id: UUID().uuidString, sentDate: Date(), type: .text("Sounds horrible!!") )
    
    static let fewMessages = [message1, message2]
    
    static let someMessages = [message1, message2, message3, message4]
    
    static let manyMessages = [message1, message2, message3, message4, message5, message1, message2, message3, message4, message5]
    
}
