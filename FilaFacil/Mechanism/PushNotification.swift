//
//  RegisterForPushNotifications.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 18/10/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

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
            
            notificationInfo.alertLocalizationKey = "FilaFacil_" + category.rawValue
            notificationInfo.alertBody = "Nova questão na fila " + category.rawValue + "."
            notificationInfo.shouldBadge = true

            subscription.notificationInfo = notificationInfo
            
            dao.publicDB.save(subscription, completionHandler: {subscription, error in
                semaphore.signal()
                if error == nil {
                    print("Gravei\n \(subscription)")
                } else {
                    print("\nDEU RUIM\n " + error.debugDescription)
                }
            })
        }
    }
    
    static func removeSubscriptions(categoriesQuestion: [CategoryQuestionType]) {
        
    }
    
}
