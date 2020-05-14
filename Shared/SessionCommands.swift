//
//  SessionCommands.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 13.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import UIKit
import WatchConnectivity

// Define an interface to wrap Watch Connectivity APIs and
// bridge the UI. Shared by the iOS app and watchOS app.
//
protocol SessionCommands {
    func sendMessage(_ message: [String: Any])
    func sendAppContextMessage(_ userInfo: [String: Any])
}

// Implement the commands. Every command handles the communication and notifies clients
// when WCSession status changes or data flows. Shared by the iOS app and watchOS app.
//
extension SessionCommands {
    func sendMessage(_ message: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activeted yet! No Message sent!")
            return
        }
        
        WCSession.default.sendMessage(message, replyHandler: { replyMessage in
            print("Message \"\(message)\" sent.")
        }, errorHandler: { error in
            print("Error while sending message \"\(message)\":\n\(error)")
        })
    }
    
    func sendAppContextMessage(_ applicationContext: [String: Any]) {
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
    
    #if os(watchOS)
    func requestAppContextFromPhone() {
        sendAppContextMessage([TransferKeys.requestAppContextFromPhone.rawValue : true])
    }
    #endif
    
    func sendAppContext(userData: UserData) {
        let dict = userData.getUserDataAsDictionary()
        var translatedDict: [String: Any] = [:]
        
        for (key, value) in dict {
            translatedDict[key.rawValue] = value
        }
        
        sendAppContextMessage(translatedDict)
    }
}
