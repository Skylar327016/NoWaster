
import SwiftUI
import CloudKit
import MapKit
import Firebase

final class FirstStartUpViewModel: ObservableObject {
    
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
    @Published var userCreating = false
    @Published var userCreated = false
    @Published var hasLocationSet = false
    
    private func isValidInfo() -> Bool{
        guard !username.isEmpty, avatar != .man, !bio.isEmpty, bio.count <= 100, userLocation != nil else {
            alertItem = AlertContext.invalidUserInfo
            return false
        }
        return true
    }
    
    
    func setLocation(with customRegion: MKCoordinateRegion) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.userLocation = CLLocation(latitude: customRegion.center.latitude, longitude: customRegion.center.longitude)
        }
    }
    
    
    func createUser(){
        guard isValidInfo(), let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        DispatchQueue.main.async { self.userCreating = true }
        
        let user = CKRecord(recordType: RecordType.user)
        user[User.kUid] = uid
        user[User.kUsername] = username
        user[User.kAvatar] = avatar.convertToCKAsset(with: user.recordID.recordName)
        user[User.kBio] = bio
        user[User.kGiftLocation] = userLocation
        
        CloudKitManager.shared.save(record: user) {[weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.userCreating = false
                switch result {
                
                case .success(let record):
                    CloudKitManager.shared.user = record
                    self.userCreated = true
                    
                case .failure(_):
                    self.userCreated = false
                    self.alertItem = AlertContext.createUserFailure
                }
            }
        }
    }
}
