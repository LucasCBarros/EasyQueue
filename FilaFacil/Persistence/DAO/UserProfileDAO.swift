//
//  UserProfileDAO.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit

extension ProfileType {
    init(withString: String?) {
        switch withString {
        case "Student":
            self = .user
        case "Teacher":
            self = .admin
        default:
            self = ProfileType.ptDefault
        }
    }
}

class UserProfileDAO: DAO {
    
    /// Login Functions
    // Create a new user
    func createUserProfile(userID: String, username: String, profileType: String? = nil, email: String, deviceID: String) {
//        // Retrieve users DeviceID from defaults
//        let userDeviceID = UserDefaults.standard.string(forKey: "userDeviceID")  ?? ""
//
//        let newUser = UserProfile(dictionary: [
//            "userID": userID,
//            "username": username,
//            "email": email,
//            "deviceID": userDeviceID
//            ])
//
//        let path = "Users"
//
//        if let profileType = newUser.profileType {
//            let path = "Admins/\(userID)"
//            let newAdmin = ProfileType(userID: userID, userName: newUser.username, profileType: profileType)
//
//            self.create(dump: ProfileType.self, object: newAdmin, path: path, newObjectID: userID)
//        }
//        self.create(dump: UserProfile.self, object: newUser, path: path, newObjectID: userID)
    }
    
    func editUser(user: UserProfile) {
//        let path = "Users/"
//
//        self.editByID(dump: UserProfile.self, newObject: user, path: path, objectID: user.userID)
    }
    
    func retrieveImage(for userId: String, with completionHlandler: @escaping (Data?, Error?) -> Void) {
        let recordId  = CKRecordID(recordName: userId)
        //let reference = CKReference(recordID: recordId, action: CKReferenceAction.deleteSelf)
        let reference = userId
        let predicate = NSPredicate(format: "userId == %@", reference)
        let query = CKQuery(recordType: "ProfilePhoto", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            guard let record = records?.first, let asset = record["photo"] as? CKAsset else {
                completionHlandler(nil, error)
                return
            }
            do {
                let image = try Data.init(contentsOf: asset.fileURL)
                completionHlandler(image, error)
            } catch {
                completionHlandler(nil, error)
            }
        }
    }
    
    func saveImage(_ data: Data, for userId: String, with completionHandler: @escaping (Error?) -> Void) {
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let filename = ProcessInfo.processInfo.globallyUniqueString
        let tempUrl = URL.init(fileURLWithPath: temporaryDirectory.path).appendingPathComponent(filename)
        
        do {
            try data.write(to: tempUrl, options: .atomicWrite)
        } catch {
            completionHandler(error)
            return
        }
        
        let asset = CKAsset(fileURL: tempUrl)
        
        let record = CKRecord(recordType: "ProfilePhoto")
        
        record.setObject(asset, forKey: "photo")
        record.setObject(userId as CKRecordValue, forKey: "userId")
        
        publicDB.save(record) { (_, error) in
            completionHandler(error)
        }
    }
    
    // Retrieve existing user
    func retrieveUserProfile(userID: String, completionHandler: @escaping (UserProfile?) -> Void) {
//        ref?.child("Users/\(userID)").observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
//            let user = snapshot.value as? NSDictionary
//
//            if let actualUser = user as? [AnyHashable: Any] {
//
//                let newUser = UserProfile(dictionary: actualUser)
//
//                self?.ref?.child("ProfileType/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
//                    let profileType = snapshot.value as? NSDictionary
//                    if let profileType = profileType as? [AnyHashable: Any] {
//                        newUser.profileType = ProfileType(dictionary: profileType).profileType
//                    }
//                    completionHandler(newUser)
//                })
//
//            } else {
//                completionHandler(nil)
//            }
//        })
    }
    
    /// Other Actions
    // Retrieve Current User
    func retrieveCurrentUserProfile(completionHandler: @escaping (UserProfile?) -> Void) {
        
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                return
            }
            
            //print("Got user record ID \(recordID.recordName).")
            // `recordID` is the record ID returned from CKContainer.fetchUserRecordID
            self.publicDB.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }
                
                //print("The user record is: \(record.recordID.recordName)")

                self.publicDB.fetch(withRecordID: record.recordID, completionHandler: { (result, error) in
                    if error != nil {
                        //return
                        completionHandler(nil)
                    }
                    
                    if let record = result {
                    
                        let userId = record.recordID.recordName
                        let userName = record["username"] as? String
                        let profileType = record["profileType"] as? String
                        let photoModifiedAt = record["photoModifiedAt"] as? Date
                        
                        completionHandler(UserProfile(userID: userId, username: userName!,
                                                      profileType: ProfileType(withString: profileType),
                                                      email: "gmail@gmail.com", deviceID: "12345", photoModifiedAt: photoModifiedAt!))
                    } else {
                        completionHandler(nil)
                    }
                })
                
//                let predicate = NSPredicate(format: "self contains %@", record.recordID.recordName)
//                let query = CKQuery(recordType: "Users", predicate: predicate)
//
//                self.publicDB.perform(query, inZoneWith: nil) { [unowned self] results, error in
//                    if let error = error {
//
//                        return
//                    }
//                    for result in results! {
//                        print(" >-- ")
//                        print(result)
//                    }
//                }
            }
        }
        
            // `recordID` is the record ID returned from CKContainer.fetchUserRecordID
//            self.publicDB.fetch(withRecordID: recordID) { record, error in
//                guard let record = record, error == nil else {
//                    // show off your error handling skills
//                    return
//                }
//
////                print("The user record is: \(record.object(forKey: "createdBy"))")
//            }
            
//            let predicate = NSPredicate(format: "Name == %s", recordID)
//            let predicate = NSPredicate(value: true)
//            let query = CKQuery(recordType: "Users", predicate: predicate)
//            self?.publicDB.perform(query, inZoneWith: nil, completionHandler: {records, error in
//                if let records = records {
//                    for record in records {
//                        print("ak: \(record.creatorUserRecordID)")
//                    }
//                }
//            })
//            self.curr
//            self?.privateDB.perform(query, inZoneWith: nil, completionHandler: {records, error in
//                if let records = records {
//                    print(records)
//                    for record in records {
//                        print("ak: \(record.creatorUserRecordID)")
//                    }
//                }
//            })
            
        
        
        
//        let authManager = AuthDatabaseManager()
//        let userID = authManager.retrieveCurrentUserID()
//        ref?.child("Users/\(userID)").observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
//            let user = snapshot.value as? NSDictionary
//
//            if let actualUser = user as? [AnyHashable: Any] {
//
//                let newUser = UserProfile(dictionary: actualUser)
//
//                self?.ref?.child("ProfileType/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
//                    UserDefaults.standard.set(userID, forKey: "userID")
//                    let profileType = snapshot.value as? NSDictionary
//                    if let profileType = profileType as? [AnyHashable: Any] {
//                        newUser.profileType = ProfileType(dictionary: profileType).profileType
//                        UserDefaults.standard.set(newUser.profileType, forKey: "userType")
//                    }
//
//                    completionHandler(newUser)
//                })
//
//            } else {
//                completionHandler(nil)
//            }
//        })
    }
    
    // Retrieve Users In Line
    func retrieveAllUsersInLine(completionHandler: @escaping ([UserProfile]?) -> Void) {
        let path = "Users/"

        self.retrieveAll(dump: UserProfile.self, path: path) { (userProfiles) in
            completionHandler(userProfiles)
        }
    }

    
    
    func updateUserLinePosition(userID: String, position: Int) {
        //ref?.child("Users").child(userID).child("userLinePosition").setValue(position)
    }
}
