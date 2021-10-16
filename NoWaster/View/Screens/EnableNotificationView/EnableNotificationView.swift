

import SwiftUI
import Firebase

struct EnableNotificationView: View {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State var enableNotification = false
    
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
            
            
            NavigationLink(
                destination: TestSignInView(),
                isActive: $enableNotification,
                label: {
                    Text("OK")
                        .font(.custom("Odin-Bold", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40)
                        .background(Color.brandPrimary)
                        .cornerRadius(18)
                        .padding(5)
                        .onTapGesture(perform: requestNotificationAuthorization)
                })
            
            
            NavigationLink(destination: TestSignInView()) {
                Text("Maybe Later")
                    .font(.custom("Odin-Bold", size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 40)
                    .background(Color.brandSecondary)
                    .cornerRadius(18)
                    .padding(5)
            }
            
        }
        .navigationBarHidden(true)

    }
    
    
    private func requestNotificationAuthorization() {
        let application = UIApplication.shared
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = appDelegate
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = appDelegate
        }
        
        application.registerForRemoteNotifications()
        enableNotification = true
    }
}

struct EnableNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        EnableNotificationView()
    }
}
