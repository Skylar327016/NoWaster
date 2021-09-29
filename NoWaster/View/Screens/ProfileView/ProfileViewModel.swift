

import SwiftUI
import CloudKit
import MapKit
import Firebase

final class ProfileViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var username: String = ""
    @Published var avatar: UIImage = .man
    @Published var bio: String = ""
    @Published var showingActionSheet = false
    @Published var showingImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var userLocation: CLLocation? {
        didSet {
            hasLocationSet = true
        }
    }
    @Published var isLoading = false
    @Published var hasLocationSet = false
    var userRecord: CKRecord?
    
    
    func loadUser() {
        DispatchQueue.main.async { [self] in
            guard let userRecord = CloudKitManager.shared.user else {
                alertItem = AlertContext.noUserRecord
                return
            }
            self.userRecord = userRecord
            let user = User(record: userRecord)
            username = user.username
            avatar = user.avatar?.convertToUIImage() ?? .man
            bio = user.bio
            userLocation = user.giftLocation
            hasLocationSet = true
        }
    }
    
    
    private func isValidInfo() -> Bool{
        guard !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, avatar != .man, !bio.isEmpty, bio.count <= 100, userLocation != nil else {
            
            alertItem = AlertContext.invalidUserInfo
            return false
        }
        
        return true
    }
    
    
    func setLocation(with customRegion: MKCoordinateRegion) {
        self.userLocation = CLLocation(latitude: customRegion.center.latitude, longitude: customRegion.center.longitude)
    }
    
    
    func updateUser() {
        var recordsToUpdate: [CKRecord] = []
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = true
        }
        
        guard let user = self.userRecord else {
            alertItem = AlertContext.noUserRecord
            return
        }
        
        let reference = CKRecord.Reference(recordID: user.recordID, action: .none)
        
        user[User.kUsername] = username
        user[User.kAvatar] = avatar.convertToCKAsset(with: user.recordID.recordName)
        user[User.kBio] = bio
        user[User.kGiftLocation] = userLocation
        recordsToUpdate.append(user)
        
        CloudKitManager.shared.checkIfUserIsGiver(for: reference) { [weak self] giverRecord in
            if let giverRecord = giverRecord, let self = self {
                giverRecord[Giver.kLocation] = self.userLocation
                recordsToUpdate.append(giverRecord)
            }
            
            CloudKitManager.shared.batchSave(records: recordsToUpdate) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.isLoading = false
                    switch result {
                    case .success(let records):
                        
                        for record in records {
                            if record.recordType == RecordType.user {
                                self.userRecord = record
                                CloudKitManager.shared.user = record
                                self.alertItem = AlertContext.updateUserSuccess
                            }
                        }
                        
                    case .failure(let error):
                        self.alertItem = AlertContext.createUserFailure
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Fail to sign out")
        }
        
    }
}
