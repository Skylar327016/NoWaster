

import SwiftUI

struct TestView: View {
    
    @Binding var showAgreementAndPrivacyPolicy: Bool
    var body: some View {
        VStack {
            Image(systemName: "arrow.left")
                .onTapGesture {
                    withAnimation {
                        showAgreementAndPrivacyPolicy.toggle()
                    }
                }
                
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        
    }
}

struct TestSignInView_Previews: PreviewProvider {
    static var previews: some View {
        TestView(showAgreementAndPrivacyPolicy: .constant(false))
    }
}
