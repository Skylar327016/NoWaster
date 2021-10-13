

import SwiftUI

struct EnableNotificationView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "wave.3.left")
                    .resizable()
                    .frame(width: 20, height: 40)
                    .foregroundColor(.brandPrimary)
                
                Image(systemName: "alarm.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.brandPrimary)
                    .padding()
                
                Image(systemName: "wave.3.right")
                    .resizable()
                    .frame(width: 20, height: 40)
                    .foregroundColor(.brandPrimary)
            }
           
                
            
            Text("Enable")
                .font(.custom("Odin-Bold", size: 50))
                .foregroundColor(.brandPrimary)
            
            Text("Notifications")
                .font(.custom("Odin-Bold", size: 50))
                .foregroundColor(.brandPrimary)
            
            Text("e.g. Get a expiry date alert \nor message notification")
                .font(.custom("Odin-Bold", size: 20))
                .foregroundColor(.brandPrimary)
                .padding()
            
            Spacer()
            
        }
        .navigationBarHidden(true)
    }
}

struct EnableNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        EnableNotificationView()
    }
}
