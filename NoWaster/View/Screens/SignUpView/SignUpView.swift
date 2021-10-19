

import SwiftUI

struct SignUpView: View {
    
    @State var email: String = ""
    @State var showInformationSetupView = false
    @Binding var showSignUpView: Bool
    @State var showAgreementAndPrivacyPolicy = false
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    showSignUpView.toggle()
                } label: {
                    XButton(size: 30)
                        .padding(.trailing, 20)
                        .padding(.top, 20)
                }
            }
            
            GeometryReader { geometry in
                EmailAndPasswordView(email: $email, showAgreementAndPrivacyPolicy: $showAgreementAndPrivacyPolicy)
                    .offset(x: showAgreementAndPrivacyPolicy ? -geometry.size.width : 0)
                    .opacity(showAgreementAndPrivacyPolicy ? 0 : 1)
                    .animation(.easeIn)
                    .transition(.slide)
                
                TestView(showAgreementAndPrivacyPolicy: $showAgreementAndPrivacyPolicy)
                    .offset(x: showAgreementAndPrivacyPolicy ? 0 : geometry.size.width)
                    .opacity(showAgreementAndPrivacyPolicy ? 1 : 0)
                    .animation(.easeIn)
                    .transition(.slide)
            }
            
            Spacer()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showSignUpView: .constant(false))
    }
}

struct EmailAndPasswordView: View {
    
    @Binding var email: String
    @Binding var showAgreementAndPrivacyPolicy: Bool
    
    var body: some View {
        VStack {
            Text("Sign up")
                .font(.custom("Odin-Bold", size: 24))
                .foregroundColor(.brandPrimary)
                .padding(.bottom)
            
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
                Text("6 or more characters")
                    .foregroundColor(Color.gray)
                    .font(.custom("Odin-Bold", size: 14))
                    .padding(.leading, 26)
                    .padding(.bottom, 5)
                
                Spacer()
            }
            
            HStack {
                Text("Preferred Name")
                    .font(.custom("Odin-Bold", size: 20))
                    .foregroundColor(.brandPrimary)
                    .padding(.leading, 20)
                Spacer()
            }
            
            TextField("", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.leading, 20)
                .padding(.trailing, 20)
            
            AgreementTextView()
                .padding(.leading)
                .padding(.trailing)
                .onTapGesture {
                    withAnimation{ showAgreementAndPrivacyPolicy.toggle() }
                }
            
            Button {
                
            } label: {
                Text("Agree & Join")
                    .font(.custom("Odin-Bold", size: 20))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width: 120, height: 40)
                    .background(Color.brandPrimary)
                    .cornerRadius(18)
                    .padding(.top, 10)
            }
        }
        .padding()
        
    }
}

struct AgreementTextView: View {
    var body: some View {
        HStack {
            Text("By clicking Agree & Join you agree to Nowaster's ")
                .foregroundColor(Color.gray)
                .font(.custom("Odin-Bold", size: 14))
                
                +
                
                Text("User Agreement")
                .foregroundColor(.highlightText)
                .font(.custom("Odin-Bold", size: 14))
                
                +
                
                Text(" and ")
                .foregroundColor(Color.gray)
                .font(.custom("Odin-Bold", size: 14))
                
                +
                
                Text("Privacy Policy.")
                .foregroundColor(.highlightText)
                .font(.custom("Odin-Bold", size: 14))
                
            
            Spacer()
        }
    }
}
