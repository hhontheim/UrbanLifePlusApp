//
//  Communication.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 13.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import Foundation
import WatchConnectivity
import SwiftUI

class SessionDelegater: NSObject, WCSessionDelegate, SessionCommands {
    var userData: UserData
    
    init(userData: UserData) {
        self.userData = userData
        super.init()
    }    
    
    // Called when WCSession activation state is changed.
    //
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidComplete")
    }
    
    // Called when WCSession reachability is changed.
    //
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("reachabilityDidChange")
    }
    
    // Called when a message is received and the peer doesn't need a response.
    //
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        #if os(watchOS)
        print("Did receive message from iPhone: \(message)")
        #elseif os(iOS)
        print("Did receive message from Watch: \(message)")
        #endif
        
        for (k, value) in message {
            if let key: TransferKeys = TransferKeys(rawValue: k) {
                switch key {
                case .requestAppContextFromPhone:
                    #if os(iOS)
                    if value as! Bool {
                        print("Received AppContext Update Wanted On Watch!")
                        sendAppContext(userData: userData)
                    } else {
                        print("Received AppContext Update !!!NOT!!! Wanted On Watch!")
                    }
                    #endif
                    break
                }
            } else if let key: StorageKey = StorageKey(rawValue: k) {
                print("Will save value \"\(value)\" for key \"\(key)\".")
                DispatchQueue.main.async {
                    self.userData.updateExternally(for: key, with: value)
                }
            } else {
                print("Could not cast \(k) as any Key.")
            }
        }
    }
    
    // Called when a message is received and the peer needs a response.
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        self.session(session, didReceiveMessage: message)
        replyHandler(message)
    }
    
    // Called when an application context is received.
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Received Application Context: \(applicationContext)")
        self.session(session, didReceiveMessage: applicationContext)
        #if os(watchOS)
        DispatchQueue.main.async {
            self.userData.didReceiveInitialDataFromPhone = true
        }
        #endif
    }
    
    //    // Called when a user info is received.
    //    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
    //        print("Received UserInfo: \(userInfo)")
    //        self.session(session, didReceiveMessage: userInfo)
    //    }
    //
    //    // Called when a user info was transferred.
    //    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
    //        if let error = error {
    //            print("Error while transferring UserInfo: \(error)")
    //            return
    //        }
    //        print("Transferred UserInfo!")
    //    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session.activationState.rawValue)")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // Activate the new session after having switched to a new watch.
        print("sessionDidDeactivate: \(session.activationState.rawValue)")
        session.activate()
    }
    
    func sessionWatchStateDidChange(_ session: WCSession) {
        print("sessionWatchStateDidChange: \(session.activationState.rawValue)")
    }
    #endif
}
