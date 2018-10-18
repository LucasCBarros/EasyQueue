//
//  RegisterForPushNotifications.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 18/10/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit

class PushNotifications {
    
    static let dao = DAO()
    
    static func saveSubscriptions(categoriesQuestion: [CategoryQuestionType]) {
        
        let semaphore = DispatchSemaphore(value: 1)
        
        for category in categoriesQuestion {
            semaphore.wait()
            let predicate = NSPredicate(format: "requestedTeacher = '\(category.rawValue)'")
            
            let subscription = CKQuerySubscription(recordType: "Question", predicate: predicate, options: .firesOnRecordCreation)
            
            let notificationInfo = CKNotificationInfo()
            
            notificationInfo.alertLocalizationKey = category.rawValue
            if #available(iOS 11.0, *) {
                notificationInfo.title = "Nova questão na fila " + category.rawValue
            }
            notificationInfo.alertBody = "%1$@: %2$@"
            notificationInfo.alertLocalizationArgs = ["username", "questionTitle"]
            
            notificationInfo.shouldBadge = true

            subscription.notificationInfo = notificationInfo
            
            dao.publicDB.save(subscription, completionHandler: {subscription, error in
                semaphore.signal()
                if error == nil {

                } else {
                    print("\nDEU RUIM\n " + error.debugDescription)
                }
            })
        }
    }
    
    static func removeSubscriptions(categoriesQuestion: [CategoryQuestionType]) {
        
        let categoriesNames = categoriesQuestion.map { (categorieQuestion) -> String in
            return categorieQuestion.rawValue
        }
        
        self.dao.publicDB.fetchAllSubscriptions { (subscriptions, error) in
            if let subscriptions = subscriptions {
                for subscription in subscriptions {
                    if let notificationInfo = subscription.notificationInfo, let alertLocalizationKey = notificationInfo.alertLocalizationKey,
                        categoriesNames.contains(alertLocalizationKey) {
                        self.dao.publicDB.delete(withSubscriptionID: subscription.subscriptionID, completionHandler: { (string, error) in
                            if error == nil {
                                
                            } else {
                                print("\nDEU RUIM\n " + error.debugDescription)
                            }
                        })
                    }
                }
            }
        }
        
    }
    
    static func resetBadgeNumber() {
        
        let badgeResetOperation = CKModifyBadgeOperation(badgeValue: 0)
        
        badgeResetOperation.modifyBadgeCompletionBlock = { (error) -> Void in
            if error != nil {
                print("\nError resetting badge: \(error)")
            }
            else {
                DispatchQueue.main.async {
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
        
        CKContainer.default().add(badgeResetOperation)
        
    }
    
}
