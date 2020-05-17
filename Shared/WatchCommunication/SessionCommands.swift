//
//  SessionCommands.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 13.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import UIKit
import WatchConnectivity

protocol SessionCommands {
    #if os(watchOS)
    func requestDataFromPhone()
    #endif
    
    func sendUpdateToCounterpart(_ data: [StorageKey: Data])
}

// MARK: - Public functions
extension SessionCommands {
    #if os(watchOS)
    /// Sends a request from the watch to the phone to reply with the current storage.
    func requestDataFromPhone() {
        sendMessage([TransferKey.requestDataFromPhone.rawValue: true])
    }
    #endif
    
    /// Sends new `data` to the counterpart app. Transfer will happen in background. If there is `data` on the other device to be delivered, it will be overridden!
    /// - Parameter data: Data to send.
    func sendUpdateToCounterpart(_ data: [StorageKey: Data]) {
        var substitutedKeys: [String: Data] = [:]
        
        for (key, value) in data {
            substitutedKeys[key.rawValue] = value
        }
        
        transferUserInfo([TransferKey.updateFromCounterpart.rawValue: substitutedKeys])
    }
}

//// MARK: - Wrappers
//extension SessionCommands {
//    private func sendMessage(guaranteed: Bool = true, overwriteAnyQueuedData: Bool = false, content: [String: Any]) {
//            let session = WCSession.default
//
//            if session.isReachable {
//                sendForegroundMessage(content)
//            } else {
//                sendBackgroundMessage(overwriteAnyQueuedData: overwriteAnyQueuedData, content: content)
//            }
//    }
//
//    /// Sends a message to the counterpart app. Will only be delivered if the counterpart app is running in foreground.
//    /// - Parameter message: Message to be sent.
//    private func sendForegroundMessage(_ content: [String: Any]) {
//        sendMessage(content)
//    }
//
//    /// Sends a message to the counterpart app. Will even be delivered if the counterpart app is running in background. Upon opening the counterpart app, content will be handed over. Can specify, if `content` should be added to FIFO queue.
//    /// - Parameters:
//    ///   - overwriteAnyQueuedData: If the `content` should be added to a FIFO queue.
//    ///   - content: Content to be sent.
//    private func sendBackgroundMessage(overwriteAnyQueuedData: Bool, content: [String: Any]) {
//        if overwriteAnyQueuedData {
//            updateApplicationContext(content)
//        } else {
//            transferUserInfo(content)
//        }
//    }
//}

// MARK: - Private: Actual transfer happens here.
extension SessionCommands {
    
    /// Actually sends the `message`.
    /// - Parameter message: Message to be sent.
    private func sendMessage(_ message: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activeted yet! No Message sent!")
            return
        }
        
        WCSession.default.sendMessage(message, replyHandler: { replyMessage in
            print("Message \"\(message)\" sent. Reply: \(replyMessage)")
        }, errorHandler: { error in
            print("Error while sending message \"\(message)\":\n\(error).\nSending as UserInfo...")
            self.transferUserInfo(message)
        })
    }
    
    /// Actually sends the `applicationContext`.
    /// - Parameter applicationContext: ApplicationContext to be sent.
    private func updateApplicationContext(_ applicationContext: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activeted yet! No AppContext sent!")
            return
        }
        do {
            try WCSession.default.updateApplicationContext(applicationContext)
            print("App Context \"\(applicationContext)\" on it's way...")
        } catch let error {
            print("Error while sending AppContext \"\(applicationContext)\":\n\(error)")
        }
    }
    
    /// Actually sends the `userInfo`.
    /// - Parameter userInfo: UserInfo to be sent.
    private func transferUserInfo(_ userInfo: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activeted yet! No UserInfo sent!")
            return
        }
        WCSession.default.transferUserInfo(userInfo)
        print("UserInfo \"\(userInfo)\" on it's way...")
    }
}
