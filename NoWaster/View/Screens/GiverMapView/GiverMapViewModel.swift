
import CoreLocation
import MapKit
import CloudKit

final class GiverMapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var alertItem: AlertItem?
    @Published var giverRecords: [CKRecord] = []
    @Published var showingGifter = false
    @Published var selectedGiverRecord: CKRecord?
    @Published var region = MKCoordinateRegion()
   

    func fetchUserLocation() {
        LocationManager.shared.fetchUserRegion { region in
            guard let region = region else {
                self.alertItem = AlertContext.locationDisabled
                return
            }
            
            CloudKitManager.shared.getGiverRecords { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                        case .success(let records):
                            self.region = region
                            self.giverRecords = records
                            
                        case .failure(_):
                            self.alertItem = AlertContext.failToRetrieveGifters
                    }
                }
            }
        }
    }
    
    
    func getGivers() {
        CloudKitManager.shared.getGiverRecords { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                    case .success(let records):
                        self.giverRecords = records
                        
                    case .failure(_):
                        self.alertItem = AlertContext.failToRetrieveGifters
                }
            }
        }
    }
}
