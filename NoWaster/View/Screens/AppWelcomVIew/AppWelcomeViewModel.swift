

import Foundation
import AuthenticationServices
import CryptoKit
import Firebase
import GoogleSignIn

final class AppWelcomeViewModel: NSObject, ObservableObject {
    
    fileprivate var currentNonce: String?
    @Published var signedIn = false
    
    func signInwithApple(){
        let request = createAppleIDRequest()
        let authorizationContorller = ASAuthorizationController(authorizationRequests: [request])
        authorizationContorller.delegate = self
        authorizationContorller.performRequests()
        
    }
    
    
    func createAppleIDRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let nonce = randomNonceString()
        request.nonce = sha256(nonce)
        currentNonce = nonce
        
        return request
    }
    
    
    //MARK:- Helpers
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        guard let presentingViewController = UIApplication.shared.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingViewController) { user, error in

          if let error = error {
            print(error.localizedDescription)
            return
          }

          guard let authentication = user?.authentication, let idToken = authentication.idToken else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                if let user = authResult?.user, let self = self {
                    
                    self.signedIn = true
                    DatabaseManager.shared.database.child(user.uid).setValue(["uid": user.uid])
                } else {
                    print(error?.localizedDescription)
                    return
                }
                
            }
        }
    }
}



extension AppWelcomeViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { [weak self](authResult, error) in
                if let user = authResult?.user, let self = self {
                    // User is signed in to Firebase with Apple.
                    print("Nice! You are now signed in as \(user.uid), email: \(user.email ?? "unknown")")
                    self.signedIn = true
                    DatabaseManager.shared.database.child(user.uid).setValue(["uid": user.uid])
                } else {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error?.localizedDescription)
                    return
                }
                
            }
            
        }
    }
}
