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
    func sendUserInfoMessage(_ userInfo: [String: Any])
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
    
    func sendUserInfoMessage(_ userInfo: [String: Any]) {
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activeted yet! No UserInfo sent!")
            return
        }
        WCSession.default.transferUserInfo(userInfo)
        print("User info \"\(userInfo)\" dispatched.")
    }
    
    #if os(watchOS)
    func requestUserDataFromPhone() {
        sendUserInfoMessage(["requestUserDataFromPhone" : true])
    }
    #endif
    
    #if os(iOS)
    func sendUserDataToWatch(userData: UserData) {
        sendUserInfoMessage(userData.getAllValuesAsDictionary())
    }
    #endif
}
