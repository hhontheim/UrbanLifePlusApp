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
    
    @EnvironmentObject var userData: UserData
    
    @Binding var firstTimeSeeingLoginScreenAfterClosingTheApp: Bool
    @Binding var userIsLoggedIn: Bool
    
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil
    
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
                    Text(userData.registered ? "login.existingUser" : "login.newUser")
                        .font(.headline)
                        .padding()
                    Spacer()
                    SignInWithAppleButton(registered: userData.registered)
                        .frame(width: UIScreen.screenWidth - 32, height: 60)
                        .onTapGesture(perform: handleAuthorizationAppleIDButtonPress)
                    .padding()
                }
            }
            .onAppear {
                if self.firstTimeSeeingLoginScreenAfterClosingTheApp {
                    self.firstTimeSeeingLoginScreenAfterClosingTheApp = false
                    self.performExistingAccountSetupFlows()
                }
            }
            .navigationBarTitle("login.title \(userData.registered ? ", \(userData.givenName)" : "")")
        }
    }
    
    private func handleAuthorizationAppleIDButtonPress() {
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
        appleSignInDelegates = SignInWithAppleDelegates(window: window) { appleIdCredential in
            guard let _ = appleIdCredential else {
                // Here `appleIdCredential` is `nil`. Delegate did not work properly.
                print("Error")
                self.signInSucceeded(false)
                return
            }
            guard let fullName = appleIdCredential!.fullName, let email = appleIdCredential!.email else {
                // Account exists, but Apple will only provide ID and neither `fullName` nor `email`.
                // If `fullName` or `email` are nil, account already set up here!
                self.saveUserIdInKeychain(appleIdCredential!.user)
                self.userData.userId = appleIdCredential!.user
                self.signInSucceeded(true)
                return
            }
            guard let identityToken = appleIdCredential!.identityToken, let authorizationCode = appleIdCredential!.authorizationCode else {
                self.signInSucceeded(false)
                return
            }
            // Register new account
            self.saveUserIdInKeychain(appleIdCredential!.user)
            self.storeUserInformation(appleIdCredential!.user, fullName, email, identityToken, authorizationCode)
            self.signInSucceeded(true)
        }
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = appleSignInDelegates
        authorizationController.presentationContextProvider = appleSignInDelegates
        
        authorizationController.performRequests()
    }
    

    
    private func signInSucceeded(_ success: Bool) {
        withAnimation {
            self.userIsLoggedIn = success
        }
    }
    
    private func saveUserIdInKeychain(_ userIdentifier: String) {
        do {
            try Keychain().saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
    
    private func storeUserInformation(_ id: String, _ fullName: PersonNameComponents, _ email: String, _ identityToken: Data, _ authorizationCode: Data) {
        userData.registered = true
        userData.userId = id
        userData.givenName = fullName.givenName ?? ""
        userData.familyName = fullName.familyName ?? ""
        userData.email = email
        userData.identityToken = identityToken
        userData.authorizationCode = authorizationCode
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}