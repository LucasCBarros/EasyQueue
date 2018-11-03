//
//  AuthDatabaseManager.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit

// Possible Error Codes
let wrongPassword = 17009
let userNotFound = 17011
let weakPassword = 17026
let emailInUse = 17007

let userServices = UserProfileService()

class AuthDatabaseManager: DAO {
   
    func checkSignIn(completion: @escaping(Bool) -> Void) {
        
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                return
            }
            
            self.publicDB.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {
                    return
                }
                if let auth = record["authenticated"] as? Int64 {
                    if auth != 0 {
                        completion(true)
                    }
                }
            }
        }
        completion(false)
    }
}
