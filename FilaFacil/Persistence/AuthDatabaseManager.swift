//
//  AuthDatabaseManager.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit



enum LoginError: Error {
    case emailNotRegistered
    case emailNotAuthorized
    case emailDontMatchICloudEmail
}

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
    
    func checkSignIn(completion: @escaping(Bool, Error?) -> Void) {
        
        // Busca record Id do usuário atual
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                completion(false, error)
                return
            }
            
            // Busca informações do usuário (email, apelido) através do recordId
            self.publicDB.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {
                    completion(false, error)
                    return
                }
            
                // Verifica se o usuário possui email cadastrado
                if let userEmail = record["email"] as? String {
                    
                    let predicate = NSPredicate(value: true)
                    let query = CKQuery(recordType: "VerifiedEmails", predicate: predicate)
                    
                    // Busca lista de emails autorizados a logar
                    self.publicDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                        
                        guard let records = records, error == nil else {
                            completion(false, error)
                            return
                        }
                        
                        // Converte lista de emails autorizados em um array de strings com os emails
                        let rec = records.first
                        let emailList = rec!["emailList"] as? [String]
                        
                        // Verifica se o email cadastrado pelo usuário está na lista
                        if emailList!.contains(userEmail) {
                            
                            // Se email está na lista compara o recordName obtido pelo fetch via email
                            // com o recordName obtido via fetch no usuário atual
                            self.container.discoverUserIdentity(withEmailAddress: userEmail, completionHandler: { (userIdentity, error) in
                                
                                if userIdentity?.userRecordID?.recordName == recordID.recordName {
                                    completion(true, nil)
                                } else {
                                    completion(false, LoginError.emailDontMatchICloudEmail)
                                }
                            })
                        } else {
                            completion(false, LoginError.emailNotAuthorized)
                        }
                    })
                } else {
                    completion(false, LoginError.emailNotRegistered)
                }
            }
        }
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
