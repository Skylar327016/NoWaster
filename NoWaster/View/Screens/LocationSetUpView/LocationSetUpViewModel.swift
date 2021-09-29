

import SwiftUI
import MapKit


final class LocationSetUpViewModel: ObservableObject {
    
    @Published var alertItem: AlertItem?
    @Published var searchText: String = "" { didSet { search() }}
    @Published var matchingItems: [MapItem] = []
    @Published var isEditing = false
    @Published var region = MKCoordinateRegion()
    @Published var customRegion = MKCoordinateRegion()
    
    
    
    func search() { 
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = region
        let search = MKLocalSearch(request: request)
        
        search.start { [weak self] response, _ in
            guard let response = response, let self = self else {
                return
            }
            self.matchingItems = response.mapItems.map(){ MapItem(with: $0)}
        }
    }
    
    
    func fetchUserLocation() {
        LocationManager.shared.fetchUserRegion { [weak self] region in
            guard let self = self else { return }
            if let region = region {
                DispatchQueue.main.async {
                    self.region = region
                    self.customRegion = region
                }
            } else {
                self.alertItem = AlertContext.locationDisabled
            }
        }
    }
    
    
    func moveLocation(with item: MapItem) {
        isEditing = false
        let center = CLLocationCoordinate2D(latitude: item.coordinate.latitude, longitude: item.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        self.customRegion = MKCoordinateRegion(center: center, span: span)
    }
    
    
    func locateUser() {
        DispatchQueue.main.async { [self] in
            customRegion = region
        }
    }
    
    
    func endEditing() {
        isEditing = false
        searchText = ""
        matchingItems.removeAll()
    }
}
