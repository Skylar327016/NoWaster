

import SwiftUI

struct AllowLocationView: View {
    
    @State var allowLocation = false
    
    var body: some View {
        VStack {
            Image(systemName: "iphone.radiowaves.left.and.right")
                .resizable()
                .frame(width: 60, height: 40)
                .foregroundColor(.brandPrimary)
                .padding()
            
            Text("Allow Location")
                .font(.custom("Odin-Bold", size: 40))
                .foregroundColor(.brandPrimary)
                .padding()
            
            Text("We allow food sharing")
                .font(.custom("Odin-Bold", size: 20))
                .foregroundColor(.brandPrimary)

            
            Text("Location helps you find free food")
                .font(.custom("Odin-Bold", size: 20))
                .foregroundColor(.brandPrimary)
            
            
            Spacer()
            
            
            NavigationLink(
                destination: EnableNotificationView(),
                isActive: $allowLocation,
                label: {
                    Text("OK")
                        .font(.custom("Odin-Bold", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.brandPrimary)
                        .cornerRadius(18)
                        .padding()
                        .onTapGesture(perform: requestLocation)
                })
            
        }
        .navigationBarHidden(true)
        
    }
    
    
    private func requestLocation() {
        LocationManager.shared.requestUserLocation()
        allowLocation = true
    }
}

struct AllowLocationView_Previews: PreviewProvider {
    static var previews: some View {
        AllowLocationView()
    }
}
