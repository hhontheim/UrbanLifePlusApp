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

class SessionDelegater: NSObject, WCSessionDelegate {
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
        for (key, value) in message {
            print("Got value \"\(value)\" for key \"\(key)\". Will not save, just print!")
            DispatchQueue.main.async {
                if let x = value as? String {
                    self.userData.value = x
                } else {
                    print("could not cast")
                }
            }
        }
    }
    
    // Called when a message is received and the peer needs a response.
       //
       func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
           self.session(session, didReceiveMessage: message)
           replyHandler(message) // Echo back the time stamp.
       }
    
    // Called when a user info is received.
    //
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        #if os(watchOS)
        print("User Info Start From iPhone: \(userInfo)")
        #elseif os(iOS)
        print("User Info Start From Watch: \(userInfo)")
        #endif
        self.session(session, didReceiveMessage: userInfo)
    }
    
    // Called when a user info was transferred.
    //
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        if let error = error {
            print(error)
            return
        }
        print("Transferred User Info!")
    }
    
   
    
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
