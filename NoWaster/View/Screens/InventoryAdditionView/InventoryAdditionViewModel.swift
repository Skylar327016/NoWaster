import SwiftUI
import CloudKit

final class InventoryAdditionViewModel: ObservableObject {
    @Published var alertItem: AlertItem?
    @Published var image = UIImage.foodPlaceholder
    @Published var name = ""
    @Published var expiry = Date()
    @Published var showingActionSheet = false
    @Published var showingImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var showingScanView = false
    
    
    func isValidItem() -> Bool {
        guard image != UIImage.foodPlaceholder, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return false
        }
        return true
    }
    
    func createInventoryItem(completion: @escaping (CKRecord?) -> Void ) {
        
        
        guard let user = CloudKitManager.shared.user else {
            alertItem = AlertContext.noUserRecord
            return
        }
        let userReference = CKRecord.Reference(recordID: user.recordID, action: .none)
        let inventoryItem = CKRecord(recordType: RecordType.inventoryItem)
        
        inventoryItem[InventoryItem.kName] = name
        inventoryItem[InventoryItem.kExpiry] = expiry
        inventoryItem[InventoryItem.kImage] = image.convertToCKAsset(with: inventoryItem.recordID.recordName)
        inventoryItem[InventoryItem.kIsGift] = 0
        inventoryItem[InventoryItem.kUser] = userReference
        
        CloudKitManager.shared.save(record: inventoryItem) { [weak self] result in
            switch result {
                case .success(let record):
                    NotificationManager.shared.createNotificationRequest(with: InventoryItem(record: record))
                    completion(record)

                case .failure(_):
                    guard let self = self else { return }
                    self.alertItem = AlertContext.failToAddInventoryItem
                    completion(nil)
            }
        }
    }
}
