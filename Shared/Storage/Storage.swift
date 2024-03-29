//
//  Storage.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 15.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
#if os(iOS)
import CustomerlySDK
#endif

final class Storage: ObservableObject, SessionCommands, StorageHelper {
    var bluetoothManager: BluetoothManager?
    
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    
    #if os(iOS)
    // Store in Key-Value iCloud
    #if targetEnvironment(simulator)
    static let container = UserDefaults.standard
    #else
    static let container = NSUbiquitousKeyValueStore()
    #endif
    
    #elseif os(watchOS)
    // Store locally on Watch
    static let container = UserDefaults.standard
    #endif
    
    // MARK: - Persistent
    @Published var user: User
    @Published var appState: AppState
    @Published var bluetooth: Bluetooth
    
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
        
        if let bluetoothJSON: Data = Storage.container.pull(for: .bluetooth),
            let bluetoothDecoded: Bluetooth = try? decoder.decode(Bluetooth.self, from: bluetoothJSON) {
            self.bluetooth = bluetoothDecoded
        } else {
            self.bluetooth = Bluetooth()
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
        
        if let bluetoothJSON: Data = Storage.container.pull(for: .bluetooth),
            let bluetoothDecoded: Bluetooth = try? decoder.decode(Bluetooth.self, from: bluetoothJSON) {
            self.bluetooth = bluetoothDecoded
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
        
        if let bluetoothEncoded: Data = try? encoder.encode(bluetooth) {
            Storage.container.push(bluetoothEncoded, for: .bluetooth)
            dataToSend[.bluetooth] = bluetoothEncoded
        }
        
        if bluetoothManager != nil {
            bluetoothManager?.fetchStorageUpdate()
        }
        
        Storage.container.synchronize()
        
        if shouldSendUpdateToCounterpart {
            print("Send to counterpart")
            sendUpdateToCounterpart(dataToSend)
        } else {
            print("Was remote change. Won't send update to counterpart!")
        }
        
        #if os(iOS)
        registerForCustomerly()
        #endif
    }
    
    func nuke(shouldGoToSettingsToRevokeSIWA: Bool) {
        user = User()
        appState = AppState()
        bluetooth = Bluetooth()
        appState.shouldGoToSettingsToRevokeSIWA = shouldGoToSettingsToRevokeSIWA
        persist()
    }
    
    #if os(iOS)
    func registerForCustomerly() {
        #if DEBUG
        let runMode: String = "DEBUG"
        #elseif RELEASE
        let runMode: String = "RELEASE"
        #endif
        
        Customerly.sharedInstance.registerUser(email: user.email, user_id: user.userId, name: user.name)
        Customerly.sharedInstance.setAttributes(attributes: [
            "pushToken": user.pushToken,
            "runMode": runMode
        ])
    }
    #endif
}
