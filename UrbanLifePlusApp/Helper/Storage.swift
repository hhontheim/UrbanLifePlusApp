//
//  Storage.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI
import Combine

enum StorageKey: String, CaseIterable {
    case value
    case toggle
    
    case registered
    
    case userId
    case givenName
    case familyName
    case email
    case identityToken
    case authorizationCode
}

enum TransferKeys: String, CaseIterable {
    case requestAppContextFromPhone
}

final class UserData: ObservableObject, SessionCommands {
    
    #if os(iOS)
    // Store in Key-Value iCloud
    static let container = NSUbiquitousKeyValueStore()
    
    // Update Data from Cloud
    @objc final func externalValueChanged(notification: NSNotification? = nil) {
        // TODO: Use replace method!
        value = UserData.container.string(for: .value)
        toggle = UserData.container.bool(for: .toggle)
        registered = UserData.container.bool(for: .registered)
        userId = UserData.container.string(for: .userId)
        givenName = UserData.container.string(for: .givenName)
        familyName = UserData.container.string(for: .familyName)
        email = UserData.container.string(for: .email)
        identityToken = UserData.container.data(for: .identityToken)
        authorizationCode = UserData.container.data(for: .authorizationCode)
    }
    
    #elseif os(watchOS)
    // Store locally
    static let container = UserDefaults.standard
    
    @Published var didReceiveInitialDataFromPhone = false
    #endif
    
    init() {
        value = UserData.container.string(for: .value)
        toggle = UserData.container.bool(for: .toggle)
        registered = UserData.container.bool(for: .registered)
        userId = UserData.container.string(for: .userId)
        givenName = UserData.container.string(for: .givenName)
        familyName = UserData.container.string(for: .familyName)
        email = UserData.container.string(for: .email)
        identityToken = UserData.container.data(for: .identityToken)
        authorizationCode = UserData.container.data(for: .authorizationCode)
        
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(UserData.externalValueChanged(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: UserData.container)
        #endif
    }
    
    @Published var value: String  {
        didSet {
            set(value, for: .value, oldValue: oldValue)
        }
    }
    @Published var toggle: Bool {
        didSet {
            set(toggle, for: .toggle, oldValue: oldValue)
        }
    }
    @Published var registered: Bool {
        didSet {
            set(registered, for: .registered, oldValue: oldValue)
        }
    }
    @Published var userId: String {
        didSet {
            set(userId, for: .userId, oldValue: oldValue)
        }
    }
    @Published var givenName: String {
        didSet {
            set(givenName, for: .givenName, oldValue: oldValue)
        }
    }
    @Published var familyName: String{
        didSet {
            set(familyName, for: .familyName, oldValue: oldValue)
        }
    }
    @Published var email: String {
        didSet {
            set(email, for: .email, oldValue: oldValue)
        }
    }
    @Published var identityToken: Data {
        didSet {
            set(identityToken, for: .identityToken, oldValue: oldValue)
        }
    }
    @Published var authorizationCode: Data {
        didSet {
            set(authorizationCode, for: .authorizationCode, oldValue: oldValue)
        }
    }
    
    /// Persists the passed `value`. On iOS to iCloud, on watchOS to UserDefaults.
    /// If needed, counterpard app will be updated.
    ///
    /// Runs if didSet of property was invoked.
    /// - Parameters:
    ///   - value: New value to persist.
    ///   - key: `StorageKey` to use.
    ///   - oldValue: Used to check for differences. If value was actually changed, send updated AppContext to counterpart app.
    private final func set<T: Equatable>(_ value: T, for key: StorageKey, oldValue: T) {
        // Actually save to disk and on iOS also in iCloud.
        UserData.container.set(value, forKey: key.rawValue)
        
        if value != oldValue {
            sendAppContext(userData: self)
        } else {
            print("Data not changed")
        }
    }

    final func nuke() {
        #if !targetEnvironment(simulator)
        registered = false
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
        #else
        registered = true
        userId = "XXXXXX"
        givenName = "Mustermann"
        familyName = "Max"
        email = "max.mustermann@hontheim.net"
        identityToken = Data(base64Encoded: "aWRlbnRpdHlUb2tlbg==")!
        authorizationCode = Data(base64Encoded: "YXV0aG9yaXphdGlvbkNvZGU=")!
        #endif
    }
    
    func getUserDataAsDictionary() -> [StorageKey: Any] {
        return [
            .value: value,
            .toggle: toggle,
            .registered: registered,
            .userId: userId,
            .givenName: givenName,
            .familyName: familyName,
            .email: email,
            .identityToken: identityToken,
            .authorizationCode: authorizationCode
        ]
    }
    
    func updateExternally(for key: StorageKey, with newValue: Any) {
        switch key {
        case .value:
            replace(&value, with: newValue)
            break
        case .toggle:
            replace(&toggle, with: newValue)
            break
        case .registered:
            replace(&registered, with: newValue)
            break
        case .userId:
            replace(&userId, with: newValue)
            break
        case .givenName:
            replace(&givenName, with: newValue)
            break
        case .familyName:
            replace(&familyName, with: newValue)
            break
        case .email:
            replace(&email, with: newValue)
            break
        case .identityToken:
            replace(&identityToken, with: newValue)
            break
        case .authorizationCode:
            replace(&authorizationCode, with: newValue)
            break
        }
    }
    
    func replace<T>(_ value: inout T, with newValue: Any){
        if let v = newValue as? T {
            value = v
        }
    }
}

#if os(iOS)
extension NSUbiquitousKeyValueStore: UserDataHelper {}
#elseif os(watchOS)
extension UserDefaults: UserDataHelper {}
#endif



protocol UserDataHelper {
    func string(for key: StorageKey) -> String
    func bool(for key: StorageKey) -> Bool
    func data(for key: StorageKey) -> Data
}

// Helper for fetching Data from Disk by using StorageKeys.
extension UserDataHelper {
    func string(for key: StorageKey) -> String {
        UserData.container.string(forKey: key.rawValue) ?? ""
    }
    func bool(for key: StorageKey) -> Bool {
        UserData.container.bool(forKey: key.rawValue)
    }
    func data(for key: StorageKey) -> Data {
        UserData.container.data(forKey: key.rawValue) ?? Data()
    }
}
