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
    case value = "value"
    case toggle = "toggle"
    
    case registered = "registered"
    
    case userId = "userId"
    case givenName = "givenName"
    case familyName = "familyName"
    case email = "email"
    case identityToken = "identityToken"
    case authorizationCode = "authorizationCode"
}

final class UserData: ObservableObject, SessionCommands {
    
    #if os(iOS)
    // Store in Key-Value iCloud
    static let container = NSUbiquitousKeyValueStore()
    
    // Update Data from Cloud
    @objc final func externalValueChanged(notification: NSNotification? = nil) {
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
        willSet {
            set(newValue, for: .value)
        }
    }
    @Published var toggle: Bool {
        willSet {
            set(newValue, for: .toggle)
        }
    }
    @Published var registered: Bool {
        willSet {
            set(newValue, for: .registered)
        }
    }
    @Published var userId: String {
        willSet {
            set(newValue, for: .userId)
        }
    }
    @Published var givenName: String {
        willSet {
            set(newValue, for: .givenName)
        }
    }
    @Published var familyName: String{
        willSet {
            set(newValue, for: .familyName)
        }
    }
    @Published var email: String {
        willSet {
            set(newValue, for: .email)
        }
    }
    @Published var identityToken: Data {
        willSet {
            set(newValue, for: .identityToken)
        }
    }
    @Published var authorizationCode: Data {
        willSet {
            set(newValue, for: .authorizationCode)
        }
    }
    
    private final func set(_ value: Any, for key: StorageKey) {
        UserData.container.set(value, forKey: key.rawValue)
    }
    
    final func nuke() {
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
    }
    
    
    
    func getAllValuesAsDictionary() -> [String: Any] {
        return ["": 0]
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
