//
//  UserProfileDAO.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class UserProfileDAO: DAO {
    
    /// Login Functions
    // Create a new user
    func createUserProfile(userID: String, username: String, profileType: String? = nil, email: String, deviceID: String) {
        // Retrieve users DeviceID from defaults
        let userDeviceID = UserDefaults.standard.string(forKey: "userDeviceID")  ?? ""
        
        let newUser = UserProfile(dictionary: [
            "userID": userID,
            "username": username,
            "email": email,
            "deviceID": userDeviceID
            ])
        
        let path = "Users"
        
        if let profileType = newUser.profileType {
            let path = "Admins/\(userID)"
            let newAdmin = ProfileType(userID: userID, userName: newUser.username, profileType: profileType)
            
            self.create(dump: ProfileType.self, object: newAdmin, path: path, newObjectID: userID)
        }
        self.create(dump: UserProfile.self, object: newUser, path: path, newObjectID: userID)
    }
    
    // Retrieve existing user
    func retrieveUserProfile(userID: String, completionHandler: @escaping (UserProfile?) -> Void) {
        ref?.child("Users/\(userID)").observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            let user = snapshot.value as? NSDictionary
            
            if let actualUser = user as? [AnyHashable: Any] {
                
                let newUser = UserProfile(dictionary: actualUser)
                
                self?.ref?.child("ProfileType/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let profileType = snapshot.value as? NSDictionary
                    if let profileType = profileType as? [AnyHashable: Any] {
                        newUser.profileType = ProfileType(dictionary: profileType).profileType
                    }
                    completionHandler(newUser)
                })
                
            } else {
                completionHandler(nil)
            }
        })
    }
    
    /// Other Actions
    // Retrieve Current User
    func retrieveCurrentUserProfile(completionHandler: @escaping (UserProfile?) -> Void) {
        let authManager = AuthDatabaseManager()
        let userID = authManager.retrieveCurrentUserID()
        ref?.child("Users/\(userID)").observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            let user = snapshot.value as? NSDictionary

            if let actualUser = user as? [AnyHashable: Any] {
                
                let newUser = UserProfile(dictionary: actualUser)
                
                self?.ref?.child("ProfileType/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
                    let profileType = snapshot.value as? NSDictionary
                    if let profileType = profileType as? [AnyHashable: Any] {
                        newUser.profileType = ProfileType(dictionary: profileType).profileType
                    }
                    completionHandler(newUser)
                })
                
            } else {
                completionHandler(nil)
            }
        })
    }
    
    // Retrieve Users In Line
    func retrieveAllUsersInLine(completionHandler: @escaping ([UserProfile]?) -> Void) {
        let path = "Users/"

        self.retrieveAll(dump: UserProfile.self, path: path) { (userProfiles) in
            completionHandler(userProfiles)
        }
    }

    // Remove user from Line
    func removeQuestionFromLine(lineName: String, questionID: String) {
        ref?.child("Lines").child(lineName).child(questionID).removeValue()
    }
    
    func updateUserLinePosition(userID: String, position: Int) {
        ref?.child("Users").child(userID).child("userLinePosition").setValue(position)
    }
}
