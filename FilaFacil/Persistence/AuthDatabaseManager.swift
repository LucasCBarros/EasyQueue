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
    
    func getPersonalData(completion: @escaping(String) -> Void) {
        
        container.fetchUserRecordID { (recordId, error) in
            
            if error == nil {
                
//                self.container.discoverUserIdentity(withUserRecordID: recordId!, completionHandler: { (userInfo, error) in
//                    if error != nil {
//                        print("Handle error")
//                    } else {
//                        if let userInfo = userInfo {
//                            if let nameComponents = userInfo.nameComponents {
//                                let firstName = nameComponents.givenName!
//                                let lastName = nameComponents.familyName!
//
//                                let fullName = firstName + lastName
//                                print("emailAddress =   \(userInfo.lookupInfo?.emailAddress ?? "Email")")
//                                print("phoneNumber = \(userInfo.lookupInfo?.phoneNumber ?? "PhoneNumber")")
//                                completion(fullName)
//                            } else {}
//                        } else {
//                            print("no user info")
//                        }
//                    }
//                })
            }
        }
    }
    
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
                    
                    if auth != 0 {

                        completion(true)
                        //authenticated = true
                    } else {
                        if let name = record["username"] as? String {
                            
                        } else {
                            
                            self.getPersonalData(completion: { (user) in
                                
//                                userServices.editUsername(user: user, completion: { (user) in
//                                    
//                            
//                                })
                            })
                        }
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
