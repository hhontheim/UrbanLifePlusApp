//
//  AppDelegate.swift
//  UrbanLifePlusApp
//
//  Created by Henning Hontheim on 10.05.20.
//  Copyright © 2020 Henning Hontheim. All rights reserved.
//

import UIKit
import WatchConnectivity
import SwiftUI
import UserNotifications
import CustomerlySDK
import Instabug
import BackgroundTasks

#if DEBUG
let liveMode = false
#endif

#if RELEASE
let liveMode = true
#endif

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var storage: Storage!
    var bluetoothManager: BluetoothManager!
    
    private lazy var sessionDelegater: SessionDelegater = {
        return SessionDelegater(storage: storage)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "net.hontheim.UrbanLifePlusApp.refresh", using: nil, launchHandler: { task in
            self.handleAppRefresh(task)
        })
        
        application.registerForRemoteNotifications()
        registerForPushNotifications()
        
        storage = Storage()
        bluetoothManager = BluetoothManager()
        
        storage.bluetoothManager = bluetoothManager
        bluetoothManager.storage = storage
        
        sessionDelegater = SessionDelegater(storage: storage)
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = sessionDelegater
            session.activate()
            
            print("Apple Watch is paired: \(session.isPaired)")
            print("WatchKit app is installed: \(session.isWatchAppInstalled).")
            
        } else { print("WatchConnectivity is not supported on this device") }
        
        activateCustomerly()
        activateInstabug(application, launchOptions)
        
        return true
    }
    
    func handleAppRefresh(_ task: BGTask) {
        task.expirationHandler = {
          task.setTaskCompleted(success: false)
        }
//        refreshOperation()
//        scheduleAppRefresh()
        task.setTaskCompleted(success: true)
    }
    
    func scheduleAppRefresh() {
        do {
            let request = BGProcessingTaskRequest(identifier: "net.hontheim.UrbanLifePlusApp.refresh")
            // Fetch no earlier than 15 minutes from now = 15 * 60
            request.earliestBeginDate = Date(timeIntervalSinceNow: UIApplication.backgroundFetchIntervalMinimum)
            try BGTaskScheduler.shared.submit(request)
            print("scheduled")
        } catch {
            print("Could not schedule app refresh: \(error)")
        }
    }
    
    func refreshOperation() {
        let content = UNMutableNotificationContent()
        content.title = "Background Refresh Executed!"
        content.subtitle = Date().description
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func activateCustomerly() {
        Customerly.sharedInstance.configure(appId: "a24f5811")
        Customerly.sharedInstance.activateApp()
    }
    
    func activateInstabug(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let appToken = liveMode ? "cd3e8a69524c773d05a8da64f5612db8" : "3c37aa0208e8a838565a5ad2d7071611" // ULP App
        // let appToken = liveMode ? "fc285088d5d705d5ec0e651d910c93f8" : "2a026da7ca3b0ba823c9cef873deb91b" // FL Demo
        
        Instabug.start(withToken: appToken, invocationEvents: [.none])
        Instabug.tintColor = UIColor.systemOrange
        // Instabug.showWelcomeMessage(with: liveMode ? .live : .beta)
        BugReporting.shouldCaptureViewHierarchy = true
        Replies.pushNotificationsEnabled = true
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            Replies.didReceiveRemoteNotification(notification)
        }
        
        UIApplication.shared.applicationIconBadgeNumber = Replies.unreadRepliesCount
        application.applicationIconBadgeNumber = Replies.unreadRepliesCount
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("didRegisterForRemoteNotificationsWithDeviceToken: \(deviceToken.hexString)")
        Replies.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        storage.user.pushToken = deviceToken.hexString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("didReceiveRemoteNotification: \(userInfo)")
        Replies.didReceiveRemoteNotification(userInfo)
        UIApplication.shared.applicationIconBadgeNumber = Replies.unreadRepliesCount
        application.applicationIconBadgeNumber = Replies.unreadRepliesCount
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                granted, error in
                print("Permission for Push Notifications granted: \(granted).")
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
