//
//  SignInWithApple.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 11.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI
import AuthenticationServices

struct SignInWithApple: UIViewRepresentable {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @Binding var existingUser: Bool
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {
        ASAuthorizationAppleIDButton(authorizationButtonType: existingUser ? .continue : .signUp, authorizationButtonStyle: colorScheme == .light ? .black : .white)
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}
