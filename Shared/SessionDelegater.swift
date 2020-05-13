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
        print("From iPhone: \(message)")
        #elseif os(iOS)
        print("From Watch: \(message)")
        #endif
        for (key, value) in message {
            print("Will save \"\(value)\" for key \"\(key)\".")
            DispatchQueue.main.async {
                
                switch key {
                case StorageKey.toggleMessage:
                    self.userData.toggleMessage = value as! Bool
                    break
                case StorageKey.toggleUserInfo:
                    self.userData.toggleUserInfo = value as! Bool
                    break
                case StorageKey.value:
                    self.userData.value = value as! String
                    break
                default:
                    break
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        #if os(watchOS)
        print("User Info Start From iPhone: \(userInfo)")
        #elseif os(iOS)
        print("User Info Start From Watch: \(userInfo)")
        #endif
        self.session(session, didReceiveMessage: userInfo)
    }
    
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        if let error = error {
            print(error)
        }
        #if os(watchOS)
        print("User Info Ended From iPhone")
        #elseif os(iOS)
        print("User Info End From Watch")
        #endif
    }
    
    // Called when a message is received and the peer needs a response.
    //
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        self.session(session, didReceiveMessage: message)
        replyHandler(message) // Echo back the time stamp.
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
