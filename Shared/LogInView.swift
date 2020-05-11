//
//  Test.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI
import UIKit
import AuthenticationServices

struct LogInView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.window) var window: UIWindow?
    
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil
    @State var existingUser: Bool = false

    @Binding var loggedIn: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                if colorScheme == .light {
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Color.black
                        .edgesIgnoringSafeArea(.all)
                }
                VStack {
                    Spacer()
                    Text("\(self.existingUser ? "Existierender User..." : "Neuer User...")")
                    Spacer()
                    SignInWithApple(existingUser: $existingUser)
                        .frame(width: UIScreen.screenWidth - 32, height: 60)
                        .onTapGesture(perform: showAppleLogin)
                    .padding()
                }
            }
            .onAppear {
                self.performExistingAccountSetupFlows()
            }
            .navigationBarTitle("Hallo")
        }
    }
    
    private func showAppleLogin() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        performSignIn(using: [request])
    }
    
    private func performExistingAccountSetupFlows() {
        #if !targetEnvironment(simulator)
        let requests = [
            ASAuthorizationAppleIDProvider().createRequest(),
            ASAuthorizationPasswordProvider().createRequest()
        ]
        performSignIn(using: requests)
        #endif
    }
    
    private func performSignIn(using requests: [ASAuthorizationRequest]) {
        appleSignInDelegates = SignInWithAppleDelegates(window: window) { success in
            if success {
//                withAnimation {
                    self.loggedIn = true
//                }
            } else {
                // show the user an error
            }
        }
        
        let controller = ASAuthorizationController(authorizationRequests: requests)
        controller.delegate = appleSignInDelegates
        controller.presentationContextProvider = appleSignInDelegates
        
        controller.performRequests()
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
