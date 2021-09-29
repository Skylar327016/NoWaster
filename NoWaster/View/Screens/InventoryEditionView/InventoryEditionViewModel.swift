
import SwiftUI
import CloudKit

final class InventoryEditionViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var image = UIImage.foodPlaceholder
    @Published var name = ""
    @Published var expiry = Date()
    @Published var showingActionSheet = false
    @Published var showingImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var isLoading = false
    
    var inventoryItemRecord: CKRecord?
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    func isValidItem() -> Bool {
        guard image != UIImage.foodPlaceholder, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return true
    }
    
    
    func updateUI(with inventoryItem: InventoryItem) {
        name = inventoryItem.name
        image = inventoryItem.image?.convertToUIImage() ?? .foodPlaceholder
        expiry = inventoryItem.expiry
    }
    
    
    func fetchRecord(with inventoryItemId: CKRecord.ID){
        
        CloudKitManager.shared.fetchRecord(with: inventoryItemId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            
                case .success(let record):
                    self.inventoryItemRecord = record
                    
                case .failure(_):
                    self.alertItem = AlertContext.failToRemoveInventoryItem
            }
        }
    }
    
    
    func updateRecord(completion: @escaping (CKRecord?) -> Void){
        
        guard let inventoryItemRecord = inventoryItemRecord else {
            completion(nil)
            return
        }
        
        inventoryItemRecord[InventoryItem.kName] = name
        inventoryItemRecord[InventoryItem.kImage] = image.convertToCKAsset(with: inventoryItemRecord.recordID.recordName)
        inventoryItemRecord[InventoryItem.kExpiry] = expiry
        
        
        CloudKitManager.shared.save(record: inventoryItemRecord) { result in
            switch result {
            case .success(let record):
                completion(record)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    func updateRecordExpiry(completion: @escaping (CKRecord?) -> Void){
        guard let inventoryItemRecord = inventoryItemRecord else {
            completion(nil)
            return
        }
        guard let expiry = inventoryItemRecord[InventoryItem.kExpiry] as? Date else {
            alertItem = AlertContext.failToExtendExpiry
            return
        }
        inventoryItemRecord[InventoryItem.kExpiry] = expiry.addingTimeInterval(24 * 60 * 60)
        
        CloudKitManager.shared.save(record: inventoryItemRecord) { result in
            switch result {
            case .success(let record):
                NotificationManager.shared.updateNotificationRequest(with: InventoryItem(record: record))
                completion(record)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
    
    
    func updateRecordToGift(completion: @escaping (CKRecord?) -> Void) {
        guard let user = CloudKitManager.shared.user, let inventoryItemRecord = inventoryItemRecord else {
            completion(nil)
            return
        }
        
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
        inventoryItemRecord[InventoryItem.kIsGift] = 1
        
        CloudKitManager.shared.checkIfUserIsGiver(for: userReference) { giver in
            if let _ = giver {
                CloudKitManager.shared.save(record: inventoryItemRecord) { result in
                    switch result {
                    case .success(let record):
                        
                        completion(record)
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }
            } else {
                let giverRecord = CKRecord(recordType: RecordType.giver)
                giverRecord[Giver.kUser] = userReference
                giverRecord[Giver.kLocation] = user[User.kGiftLocation]
                
                CloudKitManager.shared.batchSave(records: [inventoryItemRecord, giverRecord]) { result in
                    switch result {
                    case .success(let reocords):
                        for record in reocords where record.recordType == RecordType.inventoryItem {
                            NotificationManager.shared.removeNotificationRequest(with: record.recordID.recordName)
                            completion(record)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(nil)
                    }
                }
            }
        }
        
        
        
    }
    
    
    func deleteRecord(completion: @escaping (CKRecord.ID?) -> Void) {
        guard let inventoryItemRecord = inventoryItemRecord else {
            completion(nil)
            return
        }
        
        CloudKitManager.shared.delete(recordId: inventoryItemRecord.recordID) { result in
            switch result {
            
            case .success(let recordId):
                NotificationManager.shared.removeNotificationRequest(with: recordId.recordName)
                completion(recordId)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}
