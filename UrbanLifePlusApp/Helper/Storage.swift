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

final class UserData: ObservableObject, SessionCommands {
    
    #if os(iOS)
    static let container = NSUbiquitousKeyValueStore()
    #elseif os(watchOS)
    static let container = UserDefaults.standard
    #endif
    
    init() {
        value = UserData.container.string(forKey: StorageKey.value) ?? ""
        toggleMessage = UserData.container.bool(forKey: StorageKey.toggleMessage)
        toggleUserInfo = UserData.container.bool(forKey: StorageKey.toggleUserInfo)
        registered = UserData.container.bool(forKey: StorageKey.registered)
        userId = UserData.container.string(forKey: StorageKey.userId) ?? ""
        givenName = UserData.container.string(forKey: StorageKey.givenName) ?? ""
        familyName = UserData.container.string(forKey: StorageKey.familyName) ?? ""
        email = UserData.container.string(forKey: StorageKey.email) ?? ""
        identityToken = UserData.container.data(forKey: StorageKey.identityToken) ?? Data()
        authorizationCode = UserData.container.data(forKey: StorageKey.authorizationCode) ?? Data()
        
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(UserData.externalValueChanged(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: UserData.container)
        #endif
    }
    
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
    
    private final func set(_ value: Any, for key: String) {
        UserData.container.set(value, forKey: key)
    }
    
    final func nuke() {
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
    }
    
    // Update Data from Cloud
    @objc final func externalValueChanged(notification: NSNotification? = nil) {
        value = UserData.container.string(forKey: StorageKey.value) ?? ""
        toggleMessage = UserData.container.bool(forKey: StorageKey.toggleMessage)
        toggleUserInfo = UserData.container.bool(forKey: StorageKey.toggleUserInfo)
        registered = UserData.container.bool(forKey: StorageKey.registered)
        userId = UserData.container.string(forKey: StorageKey.userId) ?? ""
        givenName = UserData.container.string(forKey: StorageKey.givenName) ?? ""
        familyName = UserData.container.string(forKey: StorageKey.familyName) ?? ""
        email = UserData.container.string(forKey: StorageKey.email) ?? ""
        identityToken = UserData.container.data(forKey: StorageKey.identityToken) ?? Data()
        authorizationCode = UserData.container.data(forKey: StorageKey.authorizationCode) ?? Data()
    }
    
    func getAllValuesAsDictionary() -> [String: Any] {
        return ["": 0]
    }
}
