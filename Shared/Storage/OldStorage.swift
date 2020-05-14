//
//  Storage.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 12.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//
/*
import SwiftUI
import Combine

final class UserDataXYZ: ObservableObject, SessionCommands {

    
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
        } else {
            print("Errorrrrrr: \(value.self)")
        }
    }
}
*/
