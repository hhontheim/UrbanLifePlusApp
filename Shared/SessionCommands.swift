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
    func sendMessage(_ message: [String: Any]) -> Bool
}

// Implement the commands. Every command handles the communication and notifies clients
// when WCSession status changes or data flows. Shared by the iOS app and watchOS app.
//
extension SessionCommands {
    func sendMessage(_ message: [String: Any]) -> Bool {
        var succeeded: Bool = false
        
        guard WCSession.default.activationState == .activated else {
            print("WCSession is not activeted yet!")
            return succeeded
        }

        WCSession.default.sendMessage(message, replyHandler: { replyMessage in
            succeeded = true
        }, errorHandler: { error in
            succeeded = false
            print(error)
        })
        return succeeded
    }
}
