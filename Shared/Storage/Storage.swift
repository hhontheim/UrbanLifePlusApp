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

// Shared between devices. Persistent.
struct User: Codable {
    // Data from Sign In With Apple
    var userId: String
    var givenName: String
    var familyName: String
    var email: String
    var identityToken: Data
    var authorizationCode: Data
    
    init() {
        userId = ""
        givenName = ""
        familyName = ""
        email = ""
        identityToken = Data()
        authorizationCode = Data()
    }
}

// Shared between devices. Persistent.
struct AppState: Codable {
    var userIsRegistered: Bool
    var userIsLoggedIn: Bool
    var shouldGoToSettingsToRevokeSIWA: Bool
    
    init() {
        userIsRegistered = false
        userIsLoggedIn = false
        shouldGoToSettingsToRevokeSIWA = false
    }
}

// Local storage. Not persistent.
struct Local: Codable {
    var firstTimeSeeingLoginScreenAfterClosingTheApp: Bool
    
    init() {
        firstTimeSeeingLoginScreenAfterClosingTheApp = true
    }
}

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
    @Published var appState: AppState
    
    // MARK: - Non-Persistent
    @Published var local: Local
    
    // MARK: - Init
    init() {
        if let userJSON: Data = Storage.container.pull(for: .user),
            let userDecoded: User = try? decoder.decode(User.self, from: userJSON) {
            self.user = userDecoded
        } else {
            self.user = User()
        }
        
        if let appStateJSON: Data = Storage.container.pull(for: .appState),
            let appStateDecoded: AppState = try? decoder.decode(AppState.self, from: appStateJSON) {
            self.appState = appStateDecoded
        } else {
            self.appState = AppState()
        }
        
        local = Local()
        
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
        
        if let appStateJSON: Data = Storage.container.pull(for: .appState),
            let appStateDecoded: AppState = try? decoder.decode(AppState.self, from: appStateJSON) {
            self.appState = appStateDecoded
        }
        persist()
    }
    
    func persist(shouldSendUpdateToCounterpart: Bool = true) {
        var dataToSend: [StorageKey: Data] = [:]
        
        if let userEncoded: Data = try? encoder.encode(user)  {
            Storage.container.push(userEncoded, for: .user)
            dataToSend[.user] = userEncoded
        }
        
        if let appStateEncoded: Data = try? encoder.encode(appState) {
            Storage.container.push(appStateEncoded, for: .appState)
            dataToSend[.appState] = appStateEncoded
        }
        
        Storage.container.synchronize()
        
        if shouldSendUpdateToCounterpart {
            print("Send to counterpart")
            sendUpdateToCounterpart(dataToSend)
        } else {
            print("Was remote change. Won't send update to counterpart!")
        }
    }
    
    func nuke(shouldGoToSettingsToRevokeSIWA: Bool) {
        #if !targetEnvironment(simulator)
        user = User()
        appState = AppState()
        appState.shouldGoToSettingsToRevokeSIWA = shouldGoToSettingsToRevokeSIWA
        persist()
        #endif
    }
}

enum StorageKey: String, CaseIterable {
    case user
    case appState
    case local
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
