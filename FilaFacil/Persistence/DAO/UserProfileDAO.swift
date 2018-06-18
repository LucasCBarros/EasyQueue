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
    func createUserProfile(userID: String, username: String, profileType: String, email: String,
                           questionID: String ) {
        // Retrieve users DeviceID from defaults
        let userDeviceID = UserDefaults.standard.string(forKey: "userDeviceID")  ?? ""
        
        let newUser = UserProfile(dictionary: [
            "userID": userID,
            "username": username,
            "profileType": profileType,
            "email": email,
            "questionID": "",
            "userInLine": false,
            "userLinePosition": 0,
            "deviceID": userDeviceID,
            "userPhoto": ""
            ])
        
        let path = "Users"
        
        self.create(dump: UserProfile.self, object: newUser, path: path, newObjectID: userID)
    }
    
    // Retrieve existing user
    func retrieveUserProfile(userID: String, completionHandler: @escaping (UserProfile?) -> Void) {
        ref?.child("Users/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as? NSDictionary
            
            if let actualUser = user {
                
                let newUser = UserProfile(dictionary: (actualUser as? [AnyHashable: Any])!)
                
                completionHandler(newUser)
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
        ref?.child("Users/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as? NSDictionary
            
            if let actualUser = user {
                
                let newUser = UserProfile(dictionary: (actualUser as? [AnyHashable: Any])!)
                
                completionHandler(newUser)
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
    func removeUserFromLine(userID: String, questionID: String) {
        ref?.child("Questions").child(questionID).removeValue()
        
        ref?.child("Users").child(userID).child("questionID").setValue("")
        ref?.child("Users").child(userID).child("userInLine").setValue(false)
        ref?.child("Users").child(userID).child("userLinePosition").setValue(0)
    }
    
    func updateUserLinePosition(userID: String, position: Int) {
        ref?.child("Users").child(userID).child("userLinePosition").setValue(position)
    }
}
