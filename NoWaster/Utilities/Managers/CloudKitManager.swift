import SwiftUI
import CloudKit

final class CloudKitManager: ObservableObject {
    
    static let shared = CloudKitManager()
    
    @Published var user: CKRecord?
    @Published var importedRecords: [CKRecord] = []
    
    private init(){}
    
    
    func getUserInventoryList(with uid: String, completion: @escaping ([CKRecord]?) -> Void) {
        let predicate = NSPredicate(format: "uid == %@", uid)
        let query = CKQuery(recordType: RecordType.user, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                completion(nil)
                return
            }
            
            if !records.isEmpty {
                let user = CKRecord.Reference(record: records[0], action: .none)
                let predicate = NSPredicate(format: "user == %@", user)
                let query = CKQuery(recordType: RecordType.inventoryItem, predicate: predicate)
                CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
                    guard var records = records, error == nil else {
                        completion(nil)
                        return
                    }
                    records.removeAll(where: {$0[InventoryItem.kIsGift] == 1})
                    completion(records)
                }
            } else {
                completion([CKRecord]())
            }
        }
    }
    
    
    func fetchUserRecord(with uid: String, completion: @escaping (CKRecord?) -> Void) {  
        let predicate = NSPredicate(format: "uid == %@", uid)
        let query = CKQuery(recordType: RecordType.user, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                completion(nil)
                return
            }
            
            if records.isEmpty {
                completion(nil)
            } else {
                completion(records[0])
            }
        }
    }
    
    
    func checkIfUserIsGiver(for user: CKRecord.Reference, completion: @escaping (CKRecord?) -> Void) {
        let predicate = NSPredicate(format: "user == %@", user)
        let query = CKQuery(recordType: RecordType.giver, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            
            guard let records = records, error == nil else {
                completion(nil)
                return
            }
            
            if records.isEmpty {
                completion(nil)
            } else {
                completion(records[0])
            }
        }
    }
    
    
    func getGiverRecords(completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.giver, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard let records = records, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(records))
        }
    }
    
    
    
    func getUserGiftList(for user: CKRecord.Reference, completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        
        let predicate = NSPredicate(format: "user == %@", user)
        let query = CKQuery(recordType: RecordType.inventoryItem, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard var records = records, error == nil else {
                completion(.failure(error!))
                return
            }
            records.removeAll(where: {$0[InventoryItem.kIsGift] == 0})
            completion(.success(records))
        }
    }
    

    func batchSave(records: [CKRecord], completion: @escaping (Result<[CKRecord], Error>) -> Void) {
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecords, error in
            guard let savedRecords = savedRecords, error == nil else {
                DispatchQueue.main.async {
                    print("error = \(error.debugDescription)")
                }
                completion(.failure(error!))
                return
            }
            
            completion(.success(savedRecords))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func batchDelete(recordIds: [CKRecord.ID], completed: @escaping (Result<[CKRecord.ID], Error>) -> Void) {
        let operation = CKModifyRecordsOperation( recordIDsToDelete: recordIds)
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecords, error in
            guard let deletedRecords = deletedRecords, error == nil else {
                completed(.failure(error!))
                return
            }
            
            completed(.success(deletedRecords))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func fetchRecord(with id: CKRecord.ID, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(record))
        }
    }
    
    
    func save(record: CKRecord, completion: @escaping (Result<CKRecord, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(record))
        }
    }
    
    
    func delete(recordId: CKRecord.ID, completed: @escaping (Result<CKRecord.ID, Error>) -> Void) {
        CKContainer.default().publicCloudDatabase.delete(withRecordID: recordId) { recordId, error in
            guard let recordId = recordId, error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(recordId))
        }
    }
}
