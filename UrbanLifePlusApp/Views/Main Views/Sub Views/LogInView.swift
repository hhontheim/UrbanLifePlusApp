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
import CustomerlySDK

struct LogInView: View {
    @Environment(\.window) var window: UIWindow?
    
    @EnvironmentObject var storage: Storage
        
    @State var appleSignInDelegates: SignInWithAppleDelegates! = nil
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text(storage.appState.userIsRegistered ? "login.existingUser" : "login.newUser")
                    .font(.headline)
                    .padding()
                Spacer()
                SignInWithAppleButton()
                    .frame(width: UIScreen.screenWidth - 32, height: 60)
                    .onTapGesture(perform: handleAuthorizationAppleIDButtonPress)
                    .padding()
            }
            .navigationBarTitle("login.title \(storage.appState.userIsRegistered ? ", \(storage.user.givenName)" : "")")
            .onAppear {
                if !self.storage.appState.shouldGoToSettingsToRevokeSIWA {
                    if self.storage.local.firstTimeSeeingLoginScreenAfterClosingTheApp {
                        self.storage.local.firstTimeSeeingLoginScreenAfterClosingTheApp = false
                        self.performExistingAccountSetupFlows()
                    }
                }
            }
        }
        .animation(.default)
        .transition (.move(edge: .bottom))
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
        #if targetEnvironment(simulator)
        self.storeUserInformation("simulatorUserId", PersonNameComponentsFormatter().personNameComponents(from: "Henning Hontheim")!, "henning@hontheim.net", Data(base64Encoded: "c2ltdWxhdG9ySWRlbnRpdHlUb2tlbg==")!, Data(base64Encoded: "c2ltdWxhdG9yQXV0aG9yaXphdGlvbkNvZGU=")!)
        self.signInSucceeded(true)
        #else
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
                self.storage.user.userId = appleIdCredential!.user
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
        #endif
    }
    
    
    
    private func signInSucceeded(_ success: Bool) {
        withAnimation {
            self.storage.appState.userIsLoggedIn = success
            if success {
                self.storage.persist()
            }
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
        storage.user.userId = id
        storage.user.givenName = fullName.givenName ?? ""
        storage.user.familyName = fullName.familyName ?? ""
        storage.user.email = email
        storage.user.identityToken = identityToken
        storage.user.authorizationCode = authorizationCode
        
        storage.appState.userIsRegistered = true
    }
}

extension UIScreen{
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
