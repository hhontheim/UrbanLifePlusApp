//
//  SignInWithAppleButtonWatch.swift
//  UrbanLifePlusApp WatchKit Extension
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

// This file is not used.

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonWatch: WKInterfaceObjectRepresentable {
    
    typealias WKInterfaceObjectRepresentable = WKInterfaceObjectRepresentableContext<SignInWithAppleButtonWatch>
    
    func makeWKInterfaceObject(context: WKInterfaceObjectRepresentableContext<SignInWithAppleButtonWatch>) -> WKInterfaceAuthorizationAppleIDButton {
        WKInterfaceAuthorizationAppleIDButton(style: .default, target: context.coordinator, action: #selector(Coordinator.handleAuthorizationAppleIDButtonPress))
    }
    
    func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceAuthorizationAppleIDButton, context: WKInterfaceObjectRepresentableContext<SignInWithAppleButtonWatch>) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}

class Coordinator: NSObject {
    @State var appleSignInDelegates: SignInWithAppleDelegatesWatch! = nil

    @objc func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        performSignIn(using: [request])
    }
    
    func performSignIn(using requests: [ASAuthorizationRequest]) {
        appleSignInDelegates = SignInWithAppleDelegatesWatch() { appleIdCredential in
            guard let _ = appleIdCredential else {
                // Here `appleIdCredential` is `nil`. Delegate did not work properly.
                print("Error")
                self.signInSucceeded(false)
                return
            }
            guard let _ = appleIdCredential!.fullName, let _ = appleIdCredential!.email else {
                // Account exists, but Apple will only provide ID and neither `fullName` nor `email`.
                // If `fullName` or `email` are nil, account already set up here!
                self.saveUserIdInKeychain(appleIdCredential!.user)
                self.signInSucceeded(true)
                return
            }
            guard let _ = appleIdCredential!.identityToken, let _ = appleIdCredential!.authorizationCode else {
                self.signInSucceeded(false)
                return
            }
            // Register new account
            self.saveUserIdInKeychain(appleIdCredential!.user)
            self.signInSucceeded(true)
        }
        
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = appleSignInDelegates
        authorizationController.performRequests()
    }
    
    private func signInSucceeded(_ success: Bool) {
        print(success)
    }
    
    private func saveUserIdInKeychain(_ userIdentifier: String) {
        do {
            try Keychain().saveItem(userIdentifier)
        } catch {
            print("Unable to save userIdentifier to keychain.")
        }
    }
}


class SignInWithAppleDelegatesWatch: NSObject {
    private let handler: (_ appleIdCredential: ASAuthorizationAppleIDCredential?) -> Void
    
    init(onSignedIn: @escaping (ASAuthorizationAppleIDCredential?) -> Void) {
        self.handler = onSignedIn
    }
}

extension SignInWithAppleDelegatesWatch: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        handler(authorization.credential as? ASAuthorizationAppleIDCredential)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.handler(nil)
    }
}
