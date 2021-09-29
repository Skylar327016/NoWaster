import MapKit

struct MapItem: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    var address: String
    
    
    init(with item: MKMapItem) {
        self.name = item.name ?? "No name"
        self.address = item.placemark.title ?? ""
        self.coordinate = item.placemark.coordinate
    }
}
