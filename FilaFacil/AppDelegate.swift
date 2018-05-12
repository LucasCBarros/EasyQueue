//
//  AppDelegate.swift
//  FilaFacil
//
//  Created by Lucas Barros on 22/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    override init() {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        
    }

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.sharedManager().enable = true

//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound], completionHandler: {(isGranted, err) in
//            if err != nil {
//                // Something went wront
//                print("HELP")
//            } else {
//                UNUserNotificationCenter.current().delegate = self
//                Messaging.messaging().delegate = self
//                
//                DispatchQueue.main.async {
//                    application.registerForRemoteNotifications()
////                    FirebaseApp.configure()
//                }
//            }
//        })
//        let token = InstanceID.instanceID().token()
//        print(token!)
    
        return true
    }
    
    func connect() {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        let newToken = InstanceID.instanceID().token()
        print(newToken)
        connect()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        connect()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
