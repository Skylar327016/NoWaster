import SwiftUI
import CloudKit

final class GiverInfoViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var isLoading = false
    @Published var giftList: [CKRecord] = []
    @Published var giftingUser: User?
    @Published var userIsSelf: Bool = false
    var giverRecord: CKRecord?
    
    
    func getGiftList(with record: CKRecord) {
        
        DispatchQueue.main.async { self.isLoading = true }
        self.giverRecord = record
        
        guard let reference = record[Giver.kUser] as? CKRecord.Reference else {
            self.alertItem = AlertContext.failToRetrieveInventoryList
            return
        }
        
        CloudKitManager.shared.getUserGiftList(for: reference) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                switch result {
                    case .success(let records):

                        self.giftList = records
                    case .failure(_):
                        self.alertItem = AlertContext.failToRetrieveInventoryList
                }
            }
        }
    }
    
    
    
    func getGiverProfile(with record: CKRecord) {
        
        DispatchQueue.main.async { self.isLoading = true }

        
        guard let userReference = record[Giver.kUser] as? CKRecord.Reference else {
            DispatchQueue.main.async { self.alertItem = AlertContext.failToRetrieveGifterInfo }
            return
        }
        
        CloudKitManager.shared.fetchRecord(with: userReference.recordID) { [weak self] result in
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                    case .success(let userRecord):
                        self.giftingUser = User(record: userRecord)
                        
                        if self.giftingUser?.id.recordName == CloudKitManager.shared.user?.recordID.recordName {
                            self.userIsSelf  = true
                        }
                    case .failure(_):
                        self.alertItem = AlertContext.failToRetrieveGifterInfo
                }
            }
        }
    }
    
    
    func retrieveGift(record: CKRecord) {
        DispatchQueue.main.async { self.isLoading = true }
        
        record[InventoryItem.kIsGift] = 0
        
        CloudKitManager.shared.save(record: record) { [weak self]result in
            DispatchQueue.main.async {
                guard let self = self, let giverRecord = self.giverRecord else { return }
                self.isLoading = false
                switch result {
                    case .success(let record):
                        self.giftList.removeAll(where: {$0.id == record.recordID})
                        
                        if self.giftList.isEmpty {
                            self.deleteGiver(with: giverRecord)
                        }
                        
                        CloudKitManager.shared.importedRecords.append(record)
                        
                    case .failure(_):
                        self.alertItem = AlertContext.failToRetrieveGift
                }
            }
        }
    }
    
    
    
    func deleteGiver(with record: CKRecord) {
        
        CloudKitManager.shared.delete(recordId: record.recordID) { result in
            switch result {
            case .success(_):
                print("delete giver")
            case .failure(_):
                print("failed to delete giver")
            }
        }
    }
}
