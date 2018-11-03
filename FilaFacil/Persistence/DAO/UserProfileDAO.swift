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
    
    func editUser(user: UserProfile, completion: @escaping (Error?) -> Void) {

        let recordID = CKRecord.ID(recordName: user.userID)
        
        publicDB.fetch(withRecordID: recordID) { record, error in
            
            if let record = record, error == nil {
                
                record.setValue(user.photo, forKey: "photoId")
                record.setValue(user.photoModifiedAt, forKey: "photoModifiedAt")
                
                self.publicDB.save(record) { _, error in
                    completion(error)
                }
            }
        }
    }
    
    func retrieveImage(for userId: String, with completionHlandler: @escaping (Data?, Date?, Error?) -> Void) {
        
        let predicate = NSPredicate(format: "userId == %@", userId)
        let query = CKQuery(recordType: "ProfilePhoto", predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            guard let record = records?.first, let asset = record["photo"] as? CKAsset,
                let date = record.modificationDate else {
                completionHlandler(nil, nil, error)
                return
            }
            do {
                let image = try Data.init(contentsOf: asset.fileURL)
                completionHlandler(image, date, error)
            } catch {
                completionHlandler(nil, nil, error)
            }
        }
    }
    
    func saveImage(_ data: Data, for user: UserProfile, with completionHandler: @escaping (UserProfile?, Error?) -> Void) {
        
        let temporaryDirectory = FileManager.default.temporaryDirectory
        let filename = ProcessInfo.processInfo.globallyUniqueString
        let tempUrl = URL.init(fileURLWithPath: temporaryDirectory.path).appendingPathComponent(filename)
        
        do {
            try data.write(to: tempUrl, options: .atomicWrite)
        } catch {
            completionHandler(nil, error)
            return
        }
        
        let asset = CKAsset(fileURL: tempUrl)
        
        if let photo = user.photo {
            
            let recordId = CKRecord.ID(recordName: photo)
            publicDB.fetch(withRecordID: recordId) { (record, error) in
                if let record = record, error == nil {
                    
                    self.updateImage(record: record, user: user, asset: asset, completionHandler: { (user, error) in
                        completionHandler(user, error)
                    })
                }
            }
            
        } else {
            let record = CKRecord(recordType: "ProfilePhoto")
            self.updateImage(record: record, user: user, asset: asset, completionHandler: { (user, error) in
                completionHandler(user, error)
            })

        }
    }
    
    private func updateImage(record: CKRecord, user: UserProfile, asset: CKAsset, completionHandler: @escaping (UserProfile?, Error?) -> Void) {
        
        record.setObject(asset, forKey: "photo")
        record.setObject(user.userID as CKRecordValue, forKey: "userId")
        
        publicDB.save(record) { (record, error) in
            if let record = record, error == nil {
                user.photo = record.recordID.recordName
                user.photoModifiedAt = record.modificationDate
                self.editUser(user: user, completion: { (error) in
                    completionHandler(user, error)
                })
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    /// Other Actions
    // Retrieve Current User
    func retrieveCurrentUserProfile(completionHandler: @escaping (UserProfile?) -> Void) {
        
        container.fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                return
            }
            
            self.publicDB.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }

                self.publicDB.fetch(withRecordID: record.recordID, completionHandler: { (result, error) in
                    if error != nil {
                        //return
                        completionHandler(nil)
                    }
                    
                    if let record = result {
                    
                        let userId = record.recordID.recordName
                        let userName = record["username"] as? String
                        let profileType = record["profileType"] as? String
                        let photoId = record["photoId"] as? String
                        let photoModifiedAt = record["photoModifiedAt"] as? Date
                        
                        completionHandler(UserProfile(userID: userId, username: userName!,
                                                      profileType: ProfileType(withString: profileType),
                                                      email: "gmail@gmail.com", deviceID: "12345", photo: photoId, photoModifiedAt: photoModifiedAt))
                    } else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    // Retrieve Users In Line
    func retrieveAllUsersInLine(completionHandler: @escaping ([UserProfile]?) -> Void) {
        let path = "Users/"

        self.retrieveAll(dump: UserProfile.self, path: path) { (userProfiles) in
            completionHandler(userProfiles)
        }
    }
}
