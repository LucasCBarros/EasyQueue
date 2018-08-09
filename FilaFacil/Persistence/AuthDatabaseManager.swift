//
//  AuthDatabaseManager.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit
//import FirebaseAuth

// Possible Error Codes
let wrongPassword = 17009
let userNotFound = 17011
let weakPassword = 17026
let emailInUse = 17007

let userServices = UserProfileService()

class AuthDatabaseManager: DAO {

    func signIn(email: String, password: String, completionHandler: @escaping (Bool, String) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            
//            if user != nil {
//                print("User logged succesfully")
//                completionHandler(true, (user?.user.uid)!)
//            } else {
//                print("Error on loging in: \(error.debugDescription)")
//                completionHandler(false, self.treatError(error: error! as NSError))
//            }
//        }
    }
//    
//    // Treat Possible errors from Firebase
//    func treatError(error: NSError) -> String {
//        var message: String
//        
//        switch error.code {
//        case wrongPassword:
//            message = "Wrong password"
//            
//        case userNotFound:
//            message = "User not found"
//            
//        case weakPassword:
//            message = "Weak password. Try one with at least 6 characters"
//            
//        case emailInUse:
//            message = "Email already in use"
//            
//        default:
//            message = String(describing: (error.localizedDescription))
//        }
//        
//        return message
//    }
    
    func register(email: String, username: String, completionHandler: @escaping (Bool, String) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            if let newUser = user {
//                print("User created succesfully")
//                completionHandler(true, newUser.user.uid)
//            } else {
//                print("Error on register: \(String(describing: (error?.localizedDescription)!))")
//                completionHandler(false, self.treatError(error: error! as NSError))
//            }
//        }
        
        let container = CKContainer.default()
        let publicDB  = container.publicCloudDatabase
        
//        let uuid = UUID().uuidString
        
        //let noteID = CKRecordID(recordName: uuid)
        
        let record = CKRecord(recordType: "Users")
        
        record.setObject("Student" as CKRecordValue, forKey: "profileType")
//      record.setObject(email as CKRecordValue, forKey: "email")
        record.setObject(username as CKRecordValue, forKey: "username")
        
        publicDB.save(record, completionHandler: { record, error in
            
            guard let record = record else {
                print("Error saving record: ", error as Any)
                return
            }
            
            print("Successfully saved record: ", record)
            
        })
        
    }
    
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            
//            print("Logged out successfully")
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
//    
//   func checkSignIn() -> Bool {
   
    func checkSignIn(completion: @escaping(Bool) -> Void) {
        
        //var authenticated: Bool = false
        
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                return
            }
            
            self.publicDB.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {

                    return
                }
            
                if let auth = record["authenticated"] as? Int64 {
                    
                    print("authHHHH: \(auth)")
                    
                    if auth != 0 {

                        completion(true)
                        //authenticated = true
                    }
                }
            }
        }
        completion(false)
 //       return authenticated
        
//        if FileManager.default.ubiquityIdentityToken != nil {
//
//            return true
//        } else {
//            return false
//        }
        
    }
//
//    func retrieveCurrentUserID() -> String {
//        let currentUser = Auth.auth().currentUser
//        
//        if currentUser != nil {
//            return (currentUser?.uid)!
//        } else {
//            print("Error finding current User!")
//            return ""
//        }
//    }
}
