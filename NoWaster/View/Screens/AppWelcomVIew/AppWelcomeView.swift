

import SwiftUI

struct AppWelcomeView: View {
    
    @StateObject var viewModel = AppWelcomeViewModel()
    @State var showSignInModalView = false
    @State var showSignUpView = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                        NavigationLink(
                            destination: AllowLocationView(),
                            isActive: $viewModel.signedIn,
                            label: {
                                AppleSignInButton()
                                    .frame(width: 250, height: 50)
                                    .onTapGesture(perform: viewModel.signInwithApple)
                            })
                        
                        
                        NavigationLink(
                            destination: AllowLocationView(),
                            isActive: $viewModel.signedIn,
                            label: {
                                GoogleSignInButton()
                                    .onTapGesture(perform: viewModel.signInWithGoogle)
                            })
                    }
                    
                    Text("- or -")
                        .font(.system(size: 20))
                    
                    HStack {
                        Button {
                            showSignUpView.toggle()
                        } label: {
                            Text("Sign up")
                                .font(.custom("Odin-Bold", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(.brandPrimary)
                                .frame(width: 125, height: 50)
                                .cornerRadius(8)
                        }
                        
                        Button {
                            withAnimation {
                                showSignInModalView.toggle()
                            }
                        } label: {
                            Text("Email sign in")
                                .font(.custom("Odin-Bold", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 120, height: 40)
                                .background(Color.brandPrimary)
                                .cornerRadius(18)
                        }
                    }
                    .padding(10)
                    
                }
                
                SignInModalView(showSignInModalView: $showSignInModalView)
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSignUpView){ SignUpView(showSignUpView: $showSignUpView) }
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


struct SignInModalView: View {
    
    @State var email: String = ""
    @Binding var showSignInModalView: Bool
    
    var body: some View {
        
        VStack {
            Spacer()
            
            ZStack {
                GeometryReader { _ in
                    EmptyView()
                }
                .background(Color.white)
                .animation(.easeIn)
                
                VStack {
                    Text("Sign in")
                        .font(.custom("Odin-Bold", size: 24))
                        .foregroundColor(.brandPrimary)
                        .padding()
                    
                    HStack {
                        Text("Email")
                            .font(.custom("Odin-Bold", size: 20))
                            .foregroundColor(.brandPrimary)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    
                    TextField("", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    HStack {
                        Text("Password")
                            .font(.custom("Odin-Bold", size: 20))
                            .foregroundColor(.brandPrimary)
                            .padding(.leading, 20)
                        Spacer()
                    }
                    
                    TextField("", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                    
                    HStack {
                        Text("Forget Password?")
                            .font(.custom("Odin-Bold", size: 16))
                            .foregroundColor(.gray)
                            .padding(10)
                        Spacer()
                    }
                    
                    
                    HStack(spacing: 10) {
                        Text("Sign in")
                            .font(.custom("Odin-Bold", size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 100, height: 40)
                            .background(Color.brandPrimary)
                            .cornerRadius(8)
                            .padding(10)
                        
                        Button {
                            withAnimation {
                                hideKeyboard()
                                showSignInModalView.toggle()
                            }
                        } label: {
                            Text("Cancel")
                                .font(.custom("Odin-Bold", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 100, height: 40)
                                .background(Color.brandSecondary)
                                .cornerRadius(8)
                                .padding(10)
                        }
                    }
                    
                    Spacer()
                }
            }
            .frame(height: 360)
            .cornerRadius(40, corners: [.topLeft, .topRight])
            .shadow(radius: 3)
            .offset(x: 0, y: 30.0)
            .animation(.linear(duration: 0.5))
            .transition(.slide)
            .offset(y: showSignInModalView ? 0 : 360)
            .opacity(showSignInModalView ? 1 : 0)
        }
    }
}
