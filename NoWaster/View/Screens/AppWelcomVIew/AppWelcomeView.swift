

import SwiftUI

struct AppWelcomeView: View {
    var body: some View {
        NavigationView {
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
                
                
                VStack {
                    AppleSignInButton()
                        .frame(width: 250, height: 50)
                    
                    GoogleSignInButton()
                    
                }
                
                Text("- or -")
                    .font(.system(size: 20))
                
                HStack {
                    Text("Sign up")
                        .font(.custom("Odin-Bold", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 125, height: 50)
                        .background(Color.brandPrimary)
                        .cornerRadius(5)
                    
                    
                    Text("Email sign in")
                        .font(.custom("Odin-Bold", size: 20))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(width: 125, height: 50)
                        .background(Color.brandPrimary)
                        .cornerRadius(5)
                }
                .padding(10)
                
            }
            .navigationBarHidden(true)
        }
        
    }
    
}

struct AppWelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AppWelcomeView()
        }
    }
}

struct GoogleSignInButton: View {
    var body: some View {
        HStack {
            Image("google")
                .resizable()
                .frame(width: 20, height: 20)
            
            Text("Sign in with Google")
                .fontWeight(.semibold)
        }
        .frame(width: 250, height: 50)
        .foregroundColor(Color.gray)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 3)
    }
}

