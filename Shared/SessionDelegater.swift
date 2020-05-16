//
//  SessionDelegater.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 13.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import WatchConnectivity
import SwiftUI

class SessionDelegater: NSObject, WCSessionDelegate {
    var storage: Storage
    
    init(storage: Storage) {
        self.storage = storage
        super.init()
    }
    
    // MARK: - Message
    // Called when a message is received and the peer doesn't need a response.
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        #if os(watchOS)
        print("Did receive message from iPhone: \(message)")
        #elseif os(iOS)
        print("Did receive message from Watch: \(message)")
        #endif
        
        for (transferKey, transferData) in message {
            if let key: TransferKey = TransferKey(rawValue: transferKey) {
                switch key {
                case .updateFromCounterpart:
                    if let data = transferData as? [StorageKey: Data] {
                        for (storageKey, value) in data {
                            print("Will save value \"\(value)\" for storageKey \"\(storageKey)\".")
                            switch storageKey {
                            case .user:
                                DispatchQueue.main.async {
                                    if let userDecoded: User = try? JSONDecoder().decode(User.self, from: value) {
                                        self.storage.user = userDecoded
                                        self.storage.persist(shouldSendUpdateToCounterpart: false)
                                    }
                                }
                                break
                            case .settings:
                                DispatchQueue.main.async {
                                    if let settingsDecoded: Settings = try? JSONDecoder().decode(Settings.self, from: value) {
                                        self.storage.settings = settingsDecoded
                                        self.storage.persist(shouldSendUpdateToCounterpart: false)
                                    }
                                }
                                break
                            }
                        }
                    }
                    break
                case .requestDataFromPhone:
                    #if os(iOS)
                    guard let requested = transferData as? Bool else {
                        print("Error handling requestDataFromPhone! Could not cast transferKey \"\(transferKey)\" as Bool!")
                        break
                    }
                    DispatchQueue.main.async {
                        self.storage.persist(shouldSendUpdateToCounterpart: requested)
                    }
                    print("Received AppContext Update Wanted On Watch! Requested: \(requested).")
                    #endif
                    break
                }
            } else {
                print("Could not cast transferKey \"\(transferKey)\" as any TransferKey!")
            }
        }
    }
    
    // Called when a message is received and the peer needs a response.
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        self.session(session, didReceiveMessage: message)
        replyHandler(message)
    }
    
    // MARK: - AppContext message
    // Called when an application context is received.
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("Received Application Context: \(applicationContext)")
        self.session(session, didReceiveMessage: applicationContext)
        #if os(watchOS)
        DispatchQueue.main.async {
            self.storage.didReceiveInitialDataFromPhone = true
        }
        #endif
    }
    
    // MARK: - UserInfo message
    // Called when a user info is received.
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print("Received UserInfo: \(userInfo)")
        self.session(session, didReceiveMessage: userInfo)
    }
    
    // Called when a user info was transferred.
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        if let error = error {
            print("Error while transferring UserInfo: \(error)")
            return
        }
        print("Transferred UserInfo!")
    }
    
    // MARK: - Session Delegates
    // Called when WCSession activation state is changed.
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete. activationState: \(session.activationState)")
    }
    
    // Called when WCSession reachability is changed.
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("reachabilityDidChange. isReachable: \(session.isReachable)")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive. activationState: \(session.activationState)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        print("sessionDidDeactivate. activationState: \(session.activationState)")
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("sessionWatchStateDidChange. activationState: \(session.activationState)")
    }
    #endif
}
