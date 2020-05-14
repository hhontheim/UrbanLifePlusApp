//
//  Storage.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 15.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

// TODO: Refactor to separate files!
import Foundation
import SwiftUI
import Combine

struct User: Codable {
    // Other Data
    var registered: Bool
    
    // Data from Sign In With Apple
    var userId: String
    var givenName: String
    var familyName: String
    var email: String
    var identityToken: Data
    var authorizationCode: Data
    
    init() {
        registered = false
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
    }
}

struct Settings: Codable {
    var value: String
    var toggle: Bool
    
    init() {
        value = ""
        toggle = false
    }
}

// TODO: Make struct?
final class Storage: ObservableObject, SessionCommands, StorageHelper {
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    #if os(iOS)
    // Store in Key-Value iCloud
    static let container = NSUbiquitousKeyValueStore()
    #elseif os(watchOS)
    // Store locally on Watch
    static let container = UserDefaults.standard
    #endif
    
    // MARK: - Persistent
    @Published var user: User
    @Published var settings: Settings
    
    // MARK: - Non-Persistent
    @Published var didReceiveInitialDataFromPhone: Bool = false
    
    // MARK: -
    init() {
        if let userJSON: Data = Storage.container.pull(for: .user),
            let userDecoded: User = try? decoder.decode(User.self, from: userJSON) {
            self.user = userDecoded
        } else {
            self.user = User()
        }
        if let settingsJSON: Data = Storage.container.pull(for: .settings),
            let settingsDecoded: Settings = try? decoder.decode(Settings.self, from: settingsJSON) {
            self.settings = settingsDecoded
        } else {
            self.settings = Settings()
        }
        
        defer {
            registerForCloudUpdate()
        }
    }
    
    private func registerForCloudUpdate() {
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(Storage.externalValueChanged(notification:)), name: NSUbiquitousKeyValueStore.didChangeExternallyNotification, object: Storage.container)
        #endif
    }
    
    @objc private final func externalValueChanged(notification: NSNotification? = nil) {
        if let userJSON: Data = Storage.container.pull(for: .user),
            let userDecoded: User = try? decoder.decode(User.self, from: userJSON) {
            self.user = userDecoded
        }
        if let settingsJSON: Data = Storage.container.pull(for: .settings),
            let settingsDecoded: Settings = try? decoder.decode(Settings.self, from: settingsJSON) {
            self.settings = settingsDecoded
        }
        persist()
    }
    
    func persist(shouldSendUpdateToCounterpart: Bool = true) {
        var dataToSend: [StorageKey: Data] = [:]
        
        if let userEncoded: Data = try? encoder.encode(user)  {
            Storage.container.push(userEncoded, for: .user)
            dataToSend[.user] = userEncoded
        }
        if let settingsEncoded: Data = try? encoder.encode(settings) {
            Storage.container.push(settingsEncoded, for: .settings)
            dataToSend[.settings] = settingsEncoded
        }
        Storage.container.synchronize()
        if shouldSendUpdateToCounterpart {
            print("Send to counterpart")
            sendUpdateToCounterpart(dataToSend)
        } else {
            print("Was remote change. Won't send update to counterpart!")
        }
    }
    
    func nuke() {
        #if !targetEnvironment(simulator)
        user = User()
        settings = Settings()
        persist()
        #endif
    }
}

enum StorageKey: String, CaseIterable {
    case user
    case settings
}

enum TransferKey: String, CaseIterable {
    case requestDataFromPhone
    case updateFromCounterpart
}

#if os(iOS)
extension NSUbiquitousKeyValueStore: StorageHelper {}
#elseif os(watchOS)
extension UserDefaults: StorageHelper {}
#endif

protocol StorageHelper {
    func pull(for key: StorageKey) -> Data?
    func push(_ data: Data, for key: StorageKey)
}

extension StorageHelper {
    func pull(for key: StorageKey) -> Data? {
        Storage.container.data(forKey: key.rawValue)
    }
    
    func push(_ data: Data, for key: StorageKey) {
        Storage.container.set(data, forKey: key.rawValue)
    }
}
