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
    case iCloudNotLoggedInDevice
    case deniedUserPermission
    case corruptedNameComponent
}

let userServices = UserProfileService.shared

class AuthDatabaseManager: DAO {
    
    func trySigin(email: String, completion: @escaping(Bool, Error?) -> Void) {
        CKContainer.default().requestApplicationPermission(.userDiscoverability) { (status, error) in
            guard status == CKContainer_Application_PermissionStatus.granted else {
                completion(false, LoginError.deniedUserPermission)
                return
            }
            
            self.container.fetchUserRecordID { userRecordID, error in
                guard let userRecordID = userRecordID, error == nil else {
                    completion(false, LoginError.iCloudNotLoggedInDevice)
                    return
                }
                
                self.sigin(userEmail: email, recordID: userRecordID, completion:{ (authenticate, error) in
                    if authenticate {
                        self.container.discoverUserIdentity(withEmailAddress: email, completionHandler: { (userIdentity, error) in
                            self.publicDB.fetch(withRecordID: userRecordID) { record, error in
                                if let record = record {
                                    guard let nameComponents = userIdentity?.nameComponents,
                                        let firstName = nameComponents.givenName else {
                                        completion(false, LoginError.corruptedNameComponent)
                                        return
                                    }
                                    record["email"] = email
                                    let lastName = nameComponents.familyName ?? ""
                                    let name = "\(firstName) \(lastName)"
                                    record["username"] = name
                                    self.publicDB.save(record, completionHandler: { _,_ in })
                                }
                            }
                        })
                    }
                    completion(authenticate, error)
                })
            }
        }
    }
    
    func checkSignin(completion: @escaping(Bool, Error?) -> Void) {
        // Busca record Id do usuário atual
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                completion(false, LoginError.iCloudNotLoggedInDevice)
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
                    self.sigin(userEmail: userEmail, recordID: recordID, completion: completion)
                } else {
                    completion(false, LoginError.emailNotRegistered)
                }
            }
        }
    }
    
    private func sigin(userEmail: String, recordID: CKRecord.ID, completion: @escaping(Bool, Error?) -> Void) {
        let predicate = NSPredicate(format: "emailList contains %@", userEmail)
        let query = CKQuery(recordType: "VerifiedEmails", predicate: predicate)
        
        // Busca lista de emails autorizados a logar
        self.publicDB.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            
            guard let records = records, error == nil else {
                completion(false, error)
                return
            }
            
            // Converte lista de emails autorizados em um array de strings com os emails
            // Verifica se o email cadastrado pelo usuário está na lista
            if let rec = records.first,
                let emailList = rec["emailList"] as? [String],
                emailList.contains(userEmail) {
                // Se email está na lista compara o recordName obtido pelo fetch via email
                // com o recordName obtido via fetch no usuário atual
                self.container.discoverUserIdentity(withEmailAddress: userEmail, completionHandler: { (userIdentity, error) in
                    guard let userIdentity = userIdentity, error == nil else {
                        completion(false, error)
                        return
                    }
                    if userIdentity.userRecordID?.recordName == recordID.recordName {
                        completion(true, nil)
                    } else {
                        completion(false, LoginError.emailDontMatchICloudEmail)
                    }
                })
            } else {
                completion(false, LoginError.emailNotAuthorized)
            }
        })
    }

}
