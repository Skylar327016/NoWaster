//
//  AppleSignInButton.swift
//  NoWaster
//
//  Created by 陳家豪 on 18/09/2021.
//

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        return ASAuthorizationAppleIDButton()
    }
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) { }
}
