//
//  AppDelegate.swift
//  FilaFacil
//
//  Created by Lucas Barros on 22/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import FirebaseCore
import IQKeyboardManagerSwift
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    override init() {
        super.init()
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //Personlayze status bar
        application.statusBarStyle = .lightContent
        UIApplication.shared.isStatusBarHidden = false
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        
        // Finds and saves users DeviceID
//        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        let deviceToken = Messaging.messaging().fcmToken
        UserDefaults.standard.set( deviceToken, forKey: "userDeviceID")
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.MessagingRegistrationTokenRefreshed, object: nil)
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map({ data -> String in
            return String(format: "%02.2hhx", data)
        })
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    @objc func tokenRefreshNotification(notification: NSNotification) {
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("InstanceID token: \(token)")
                //            User.getIDTokenForcingRefresh(refreshedToken.)
            }
        }
    }
}
