
import SwiftUI
import MapKit

struct GiverMapView: View {
    
    @StateObject var viewModel = GiverMapViewModel()
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: false, annotationItems: viewModel.giverRecords) { record in
                MapAnnotation(coordinate: Giver(record: record).location.coordinate) {
                    GiverAnnotationView(giver: Giver(record: record))
                        .onTapGesture{ viewModel.selectedGiverRecord = record }
                }
            }.ignoresSafeArea()
        }
        .accentColor(.brandPrimary)
        .onAppear(perform: viewModel.fetchUserLocation)
        .onAppear(perform: viewModel.getGivers)
        .sheet(item: $viewModel.selectedGiverRecord) { record in
            NavigationView {
               GiverInfoView(giverRecord: record, giverMapViewModel: viewModel)
            }
        }
    }
}

struct GiverMapView_Previews: PreviewProvider {
    static var previews: some View {
        GiverMapView()
    }
}


private struct GiverAnnotationView: View {
    
    let giver: Giver
    
    var isUserself: Bool {
        giver.user?.recordID.recordName == CloudKitManager.shared.user?.recordID.recordName
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(isUserself ? .brandPrimary : .brandSecondary)
                .frame(width: 40, height: 40)
            Image(systemName: "mappin")
                .resizable()
                .frame(width: 40 / 2, height: 40)
                .foregroundColor(isUserself ? .brandPrimary : .brandSecondary)
                .offset(y: 25)
            
            Image(systemName: "gift.circle.fill")
                .resizable()
                .frame(width: 35, height: 35)
                .foregroundColor(.white)
        }
    }
}
