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
    static let userId = "userId"
    static let givenName = "givenName"
    static let familyName = "familyName"
    static let email = "email"
    static let identityToken = "identityToken"
    static let authorizationCode = "authorizationCode"
    
    static let cloud = "cloud"
}

//extension PersonNameComponents {
//    func displayName(style: PersonNameComponentsFormatter.Style = .default) -> String {
//        PersonNameComponentsFormatter.localizedString(from: self, style: style)
//    }
//}

final class StorageTemp: ObservableObject {
    @Published var userIsLoggedIn: Bool = false
}

final class StorageLocal: ObservableObject {
    static let defaults = UserDefaults.standard
    
    @Published var userId: String = defaults.string(forKey: StorageKey.userId) ?? "" {
        willSet {
            set(newValue, for: StorageKey.userId)
        }
    }
    @Published var givenName: String = defaults.string(forKey: StorageKey.givenName) ?? "" {
           willSet {
               set(newValue, for: StorageKey.givenName)
           }
       }
    @Published var familyName: String = defaults.string(forKey: StorageKey.familyName) ?? "" {
        willSet {
            set(newValue, for: StorageKey.familyName)
        }
    }
    @Published var email: String = defaults.string(forKey: StorageKey.email) ?? "" {
        willSet {
            set(newValue, for: StorageKey.email)
        }
    }
    @Published var identityToken: Data = defaults.data(forKey: StorageKey.identityToken) ?? Data() {
        willSet {
            set(newValue, for: StorageKey.identityToken)
        }
    }
    @Published var authorizationCode: Data = defaults.data(forKey: StorageKey.authorizationCode) ?? Data() {
        willSet {
            set(newValue, for: StorageKey.authorizationCode)
        }
    }
    
    final func set(_ value: Any, for key: String) {
        StorageLocal.defaults.set(value, forKey: key)
    }
}

final class StorageCloud: ObservableObject {
    static let kvStore = NSUbiquitousKeyValueStore()
    
    @Published var cloud: String {
        willSet {
            set(newValue, for: StorageKey.cloud)
        }
    }
    
    init() {
        cloud = StorageCloud.kvStore.string(forKey: StorageKey.cloud) ?? ""
        
        NotificationCenter.default.addObserver(self, selector: #selector(StorageCloud.externalValueChanged(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: StorageCloud.kvStore)
    }
    
    final func set(_ value: Any, for key: String) {
        StorageCloud.kvStore.set(value, forKey: key)
    }
    
    @objc final func externalValueChanged(notification: NSNotification) {
        cloud = StorageCloud.kvStore.string(forKey: StorageKey.cloud) ?? ""
    }
}
