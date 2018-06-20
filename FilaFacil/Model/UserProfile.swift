//
//  UserProfile.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class UserProfile: NSObject, PersistenceObject {

    // Users ID
    var userID: String = ""
    
    // Users Name
    var username: String = ""
    
    // Users profile type = Student or Teacher
    var profileType: String = ""
    
    // Users E-mail
    var email: String = ""
    
    // Users Position in the Line
    var deviceID: String = ""
    
    // Users photo if it has
    var userPhoto: String = ""
    
    // Dictionary
    var dictInfo: [AnyHashable: Any]
    
    required init(dictionary: [AnyHashable: Any]) {
        
        if let userID = dictionary["userID"] as? String {
            self.userID = userID
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let profileType = dictionary["profileType"] as? String {
            self.profileType = profileType
        }
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        if let deviceID = dictionary["deviceID"] as? String {
            self.deviceID = deviceID
        }
        if let userPhoto = dictionary["userPhoto"] as? String {
            self.userPhoto = userPhoto
        }
        self.dictInfo = dictionary
    }
    
    init(userID: String, username: String, profileType: String, email: String,
         lineNumber: Int, questionID: String, userInLine: Bool, userLinePosition: Int, deviceID: String, userPhoto: String) {
        self.userID = userID
        self.username = username
        self.profileType = profileType
        self.email = email
        self.deviceID = deviceID
        self.userPhoto = userPhoto
        self.dictInfo = [
            "userID": userID,
            "username": username,
            "profileType": profileType,
            "email": email,
            "deviceID": deviceID,
            "userPhoto": userPhoto
        ]
    }
    
    func getDictInfo() -> [AnyHashable: Any] {
        return self.dictInfo
    }
}
