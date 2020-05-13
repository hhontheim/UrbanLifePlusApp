//
//  Storage.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import SwiftUI
import Combine

struct StorageKey {
    static let value = "value"
    static let toggleMessage = "toggleMessage"
    static let toggleUserInfo = "toggleUserInfo"
    
    static let registered = "registered"
    
    static let userId = "userId"
    static let givenName = "givenName"
    static let familyName = "familyName"
    static let email = "email"
    static let identityToken = "identityToken"
    static let authorizationCode = "authorizationCode"
}

//#if os(iOS)
//typealias StorageTemp = StorageTempPhone
//typealias StorageLocal = StorageLocalPhone
//#elseif os(watchOS)
//typealias StorageTemp = StorageTempWatch
//typealias StorageLocal = StorageLocalWatch
//#endif

#if os(iOS)

final class UserData: ObservableObject {
    static let kvStore = NSUbiquitousKeyValueStore()
    
    @Published var value: String  {
        willSet {
            set(newValue, for: StorageKey.value)
        }
    }
    @Published var toggleMessage: Bool {
        willSet {
            set(newValue, for: StorageKey.toggleMessage)
        }
    }
    @Published var toggleUserInfo: Bool {
        willSet {
            set(newValue, for: StorageKey.toggleUserInfo)
        }
    }
    @Published var registered: Bool {
        willSet {
            set(newValue, for: StorageKey.registered)
        }
    }
    
    @Published var userId: String {
        willSet {
            set(newValue, for: StorageKey.userId)
        }
    }
    @Published var givenName: String {
        willSet {
            set(newValue, for: StorageKey.givenName)
        }
    }
    @Published var familyName: String{
        willSet {
            set(newValue, for: StorageKey.familyName)
        }
    }
    @Published var email: String {
        willSet {
            set(newValue, for: StorageKey.email)
        }
    }
    @Published var identityToken: Data {
        willSet {
            set(newValue, for: StorageKey.identityToken)
        }
    }
    @Published var authorizationCode: Data {
        willSet {
            set(newValue, for: StorageKey.authorizationCode)
        }
    }
    
    init() {
        value = UserData.kvStore.string(forKey: StorageKey.value) ?? ""
        toggleMessage = UserData.kvStore.bool(forKey: StorageKey.toggleMessage)
        toggleUserInfo = UserData.kvStore.bool(forKey: StorageKey.toggleUserInfo)
        registered = UserData.kvStore.bool(forKey: StorageKey.registered)
        userId = UserData.kvStore.string(forKey: StorageKey.userId) ?? ""
        givenName = UserData.kvStore.string(forKey: StorageKey.givenName) ?? ""
        familyName = UserData.kvStore.string(forKey: StorageKey.familyName) ?? ""
        email = UserData.kvStore.string(forKey: StorageKey.email) ?? ""
        identityToken = UserData.kvStore.data(forKey: StorageKey.identityToken) ?? Data()
        authorizationCode = UserData.kvStore.data(forKey: StorageKey.authorizationCode) ?? Data()
        
        NotificationCenter.default.addObserver(self, selector: #selector(UserData.externalValueChanged(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: UserData.kvStore)
    }
    
    private final func set(_ value: Any, for key: String) {
        UserData.kvStore.set(value, forKey: key)
    }
    
    @objc final func externalValueChanged(notification: NSNotification? = nil) {
        value = UserData.kvStore.string(forKey: StorageKey.value) ?? ""
        toggleMessage = UserData.kvStore.bool(forKey: StorageKey.toggleMessage)
        toggleUserInfo = UserData.kvStore.bool(forKey: StorageKey.toggleUserInfo)
        registered = UserData.kvStore.bool(forKey: StorageKey.registered)
        userId = UserData.kvStore.string(forKey: StorageKey.userId) ?? ""
        givenName = UserData.kvStore.string(forKey: StorageKey.givenName) ?? ""
        familyName = UserData.kvStore.string(forKey: StorageKey.familyName) ?? ""
        email = UserData.kvStore.string(forKey: StorageKey.email) ?? ""
        identityToken = UserData.kvStore.data(forKey: StorageKey.identityToken) ?? Data()
        authorizationCode = UserData.kvStore.data(forKey: StorageKey.authorizationCode) ?? Data()
    }
    
    final func nuke() {
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
    }
}

#elseif os(watchOS)

final class UserData: ObservableObject, SessionCommands {
    static let defaults = UserDefaults.standard
    
    @Published var value: String = defaults.string(forKey: StorageKey.value) ?? "" {
        willSet {
            set(newValue, for: StorageKey.value)
        }
    }
    
    @Published var toggleMessage: Bool = defaults.bool(forKey: StorageKey.toggleMessage) {
        willSet {
            set(newValue, for: StorageKey.toggleMessage)
        }
    }
    
    @Published var toggleUserInfo: Bool = defaults.bool(forKey: StorageKey.toggleUserInfo) {
        willSet {
            set(newValue, for: StorageKey.toggleUserInfo)
        }
    }
    
    private final func set(_ value: Any, for key: String) {
        UserData.defaults.set(value, forKey: key)
    }
}

#endif
