

import SwiftUI

struct SignInView: View {
    
    @StateObject var viewModel = SignInViewModel()
    @ObservedObject var tabViewModel: AppTabViewModel
    
    var body: some View {
        ZStack {
            if viewModel.signedIn { Color.clear.onAppear(){
                DispatchQueue.main.async {
                    tabViewModel.showingSignInView = false
                    tabViewModel.authCheck()
                }
            }}
            
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Welcome to No Waster Land")
                    .font(.title)
                    .bold()
                    .foregroundColor(.brandPrimary)
                
                Text("Sign in to Join Us")
                    .font(.title)
                    .bold()
                    .foregroundColor(.brandPrimary)
                
                Image(systemName: "person.3.fill")
                    .resizable()
                    .frame(width: 300, height: 150)
                    .foregroundColor(.brandPrimary)
                
                signInButtons()
            }
        }
    }
    
    
    @ViewBuilder private func signInButtons() -> some View{
        VStack(spacing: 15) {
            Button {
                viewModel.signInwithApple()
            } label: {
                AppleSignInButton()
                    .frame(width: 300, height: 50)
            }
            
            Button {
                viewModel.signInWithGoogle()
            } label: {
                GoogleSignInButton()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(tabViewModel: AppTabViewModel())
    }
}

