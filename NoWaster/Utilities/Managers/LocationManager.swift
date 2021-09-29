import CoreLocation
import MapKit
//MARK:- Reference: https://developer.apple.com/forums/thread/651011
final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    
    private override init() {
        super.init()
    }
    
    func requestUserLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func fetchUserRegion(completion: @escaping (MKCoordinateRegion?) -> Void) {
        guard let location = manager.location else {
            completion(nil)
            return
        }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        let region = MKCoordinateRegion(center: center, span: span)
        completion(region)
    }
    
   
}

