

import SwiftUI

struct AppWelcomeView: View {
    var body: some View {
        VStack {
            Image(uiImage: .icon)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 3, x: 3, y: 3)
                .padding()
                
            Text("Nowaster")
                .font(.custom("Odin-Bold", size: 50))
                .foregroundColor(.brandPrimary)
                
            
            Text("The app helps manage food")
                .font(.custom("Odin-Bold", size: 20))
                .foregroundColor(.brandPrimary)
            
            Spacer()
            
            Button {
                
            } label: {
                Text("Start")
                    .font(.custom("Odin-Bold", size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 40)
                    .background(Color.brandPrimary)
                    .cornerRadius(18)
                    .padding()
            }
            
            
            
        }
    }
}

struct AppWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        AppWelcomeView()
    }
}
