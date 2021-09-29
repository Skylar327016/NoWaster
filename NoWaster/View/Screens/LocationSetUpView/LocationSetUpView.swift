import SwiftUI
import MapKit


struct LocationPin: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}


//MARK:- Reference: https://www.thorntech.com/how-to-search-for-location-using-apples-mapkit/
struct LocationSetUpView: View {
    
    @StateObject private var viewModel = LocationSetUpViewModel()
    @Binding var location: CLLocation?
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.customRegion, annotationItems: [LocationPin(coordinate: CLLocationCoordinate2D(latitude: viewModel.customRegion.center.latitude, longitude: viewModel.customRegion.center.longitude))]) {
                item in
                MapMarker(coordinate: item.coordinate)
            }
            
            VStack {
                searchBarView() 
                    .padding(.top)
                    .padding(.leading)
                    .padding(.trailing)
                    .onTapGesture() {
                        DispatchQueue.main.async { viewModel.isEditing = true }
                    }
                
                if viewModel.isEditing {
                    List(viewModel.matchingItems) { item in
                        LocationAddressCell(mapItem: item)
                            .onTapGesture {
                                hideKeyboard()
                                viewModel.moveLocation(with: item)
                            }
                    }
                }
                Spacer()
            }
            .background(viewModel.isEditing ? Color.white : Color.clear)
            .overlay(locateUserButton(), alignment: .bottomTrailing)
            .overlay( setLocationButton(), alignment: .bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: viewModel.fetchUserLocation)
    }
    
    
    
    @ViewBuilder func searchBarView() -> some View{
        HStack {
            TextField("Search place or postcode", text: $viewModel.searchText)
                .frame(height: 35)
                .padding(.leading, 40)
                .padding(.trailing, 30)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(.gray)))
                .overlay(Image(systemName: "magnifyingglass").padding(.leading, 10), alignment: .leading)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(displayDispissButton(), alignment: .trailing)
        }
    }
    
    
    @ViewBuilder func displayDispissButton() -> some View {
        if viewModel.isEditing {
            Button {
                DispatchQueue.main.async {
                    viewModel.endEditing()
                    hideKeyboard()
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(.trailing, 10)
                    .foregroundColor(.black)
            }
        }
    }
    
    
    @ViewBuilder func locateUserButton() -> some View{
        if !viewModel.isEditing {
            Button {
                viewModel.locateUser()
            } label: {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .shadow(radius: 5)
                    
                    Image(systemName: "location.fill")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.brandPrimary)
                }
                .padding(.bottom)
                .padding(.trailing)
            }
        }
    }
    
    
    @ViewBuilder func setLocationButton() -> some View{
        
        if !viewModel.isEditing {
            Button {
                DispatchQueue.main.async {
                    location =  CLLocation(latitude: viewModel.customRegion.center.latitude, longitude: viewModel.customRegion.center.longitude)
                    presentationMode.wrappedValue.dismiss()
                }
            } label: {
                Text("Set Location")
                    .frame(width: 120, height: 40)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .background(Color.brandPrimary)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.bottom, 25)
        }
    }
}

struct LocationSetUpView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSetUpView(location: .constant(CLLocation()))
    }
}

