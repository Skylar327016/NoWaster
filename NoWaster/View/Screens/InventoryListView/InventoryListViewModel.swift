import SwiftUI
import CloudKit
import Firebase


final class InventoryListViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var showingAdditionView = false
    @Published var showingMenu = false
    @Published var isLoading = false
    @Published var inventoryList: [CKRecord] = []
    @Published var selectedRecords: Set<CKRecord> = []
    var didLoad = false
    
    //MARK:- Menu controls
    var isSelecting = false
    
    func selected(_ record: CKRecord) -> Bool{
        return selectedRecords.contains(record)
    }
    
    func select(_ record: CKRecord) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.selectedRecords.isEmpty {
                self.showingMenu = true
            }
            self.selectedRecords.insert(record)
        }
    }
    
    func deselect(_ record: CKRecord) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.selectedRecords.remove(record)
            if self.selectedRecords.isEmpty {
                self.showingMenu = false
            }
        }
    }
    
    
    func topOffsetId() -> CKRecord.ID{
        return self.inventoryList[0].recordID
    }
    
    
    func performMenu(action: String) {
            
        DispatchQueue.main.async{ self.isLoading = true }
            
        switch action {
            case "Consumed", "Delete":
                removeItemsFromInventoryList()
                
            case "Gift":
                giftItems()
                
            case "Extend":
                extendItemsExpiryBy1()
                
            default:
                break
        }
    }
    
    
    private func removeItemsFromInventoryList(){
        let recordIds = Array(selectedRecords).map(){ $0.recordID }
        CloudKitManager.shared.batchDelete(recordIds: recordIds) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.selectedRecords.removeAll()
                switch result {
                    case .success(let recordIds):
                        for id in recordIds {
                            self.inventoryList.removeAll(where: {$0.recordID == id})
                            NotificationManager.shared.removeNotificationRequest(with: id.recordName)
                        }
                    case .failure(_):
                        self.alertItem = AlertContext.failToRemoveInventoryItem
                }
                self.isLoading = false
            }
        }
    }
    
    
    private func extendItemsExpiryBy1() {
        let recordsToUpdate = selectedRecords
        for record in recordsToUpdate {
            guard let expiry = record[InventoryItem.kExpiry] as? Date else {
                alertItem = AlertContext.failToExtendExpiry
                return
            }
            record[InventoryItem.kExpiry] = expiry.addingTimeInterval(24 * 60 * 60)
        }
        
        CloudKitManager.shared.batchSave(records: Array(recordsToUpdate)) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.selectedRecords.removeAll()
                switch result {
                case .success(var records):
                    while records.count != 0{
                        guard let updatedRecord = records.popLast() else {
                            self.alertItem = AlertContext.failToExtendExpiry
                            return
                        }
                        var position = 0
                        for record in self.inventoryList {
                            if record.recordID == updatedRecord.recordID  {
                                break
                            }
                            position += 1
                        }
                        self.inventoryList[position] = updatedRecord
                        NotificationManager.shared.updateNotificationRequest(with: InventoryItem(record: updatedRecord))
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self.alertItem = AlertContext.failToExtendExpiry
                }
                self.isLoading = false
            }
        }
    }
    
    private func giftItems(){
        var recordsToUpdate: [CKRecord] = Array(selectedRecords)
        
        guard let user = CloudKitManager.shared.user else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
        
        for record in recordsToUpdate {
            record[InventoryItem.kIsGift] = 1
        }
        CloudKitManager.shared.checkIfUserIsGiver(for: userReference) { [weak self] giver in
            if let _ = giver, let self = self {
                CloudKitManager.shared.batchSave(records: recordsToUpdate) { [weak self] result in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.selectedRecords.removeAll()
                        switch result {
                        case .success(let records):
                            for id in records.map({$0.recordID}) {
                                self.inventoryList.removeAll(where: {$0.recordID == id})
                                NotificationManager.shared.removeNotificationRequest(with: id.recordName)
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.alertItem = AlertContext.failToGiftItem
                        }
                        self.isLoading = false
                    }
                }
            } else {
                guard let self = self else { return }
                let giverRecord = CKRecord(recordType: RecordType.giver)
                giverRecord[Giver.kUser] = userReference
                giverRecord[Giver.kLocation] = user[User.kGiftLocation]
                
                recordsToUpdate.append(giverRecord)
                
                CloudKitManager.shared.batchSave(records: recordsToUpdate) { [weak self] result in
                    guard let self = self else { return }
                    DispatchQueue.main.async {
                        self.selectedRecords.removeAll()
                        switch result {
                        case .success(let records):
                            for record in records {
                                if record.recordType == RecordType.inventoryItem {
                                    self.inventoryList.removeAll(where: {$0.recordID == record.recordID})
                                    NotificationManager.shared.removeNotificationRequest(with: record.recordID.recordName)
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                            self.alertItem = AlertContext.failToGiftItem
                        }
                        self.isLoading = false
                    }
                }
            }
        }
    }
    
    
    func getInventoryList() {
        
        if didLoad { return }
        
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.isLoading = true
        }
        
        
        CloudKitManager.shared.getUserInventoryList(with: uid) { [weak self] records in
            guard let self = self else { return }
            guard let records = records else {
                DispatchQueue.main.async { self.alertItem = AlertContext.failToRetrieveInventoryList }
                return
            }
            DispatchQueue.main.async {
                self.inventoryList = records
                self.isLoading = false
                self.didLoad = true
            }
        }
    }
    
    
    func add(record: CKRecord) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.inventoryList.append(record)
            self.isLoading = false
        }
    }
    
    
    func update(updatedRecord: CKRecord) {
        var position = 0
        for record in self.inventoryList {
            if record.recordID == updatedRecord.recordID {
                break
            }
            position += 1
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.inventoryList[position] = updatedRecord
            self.isLoading = false
        }
    }
    
    
    func delete(recordId: CKRecord.ID) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.inventoryList.removeAll(where: {$0.recordID == recordId})
            self.isLoading = false
        }
    }
}
