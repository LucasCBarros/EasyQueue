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
    
    // Users Photo
//    var profilePhoto: UIImage?
    
    // Empty or questionID (To know if enters list or not)
    var questionID: String = ""
    
    // Indicator if user is in the Line
    var userInLine: Bool = false
    
    // Users Position in the Line
    var userLinePosition: Int = 0
    
    // Users Position in the Line
    var deviceID: String = ""
    
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
        if let questionID = dictionary["questionID"] as? String {
            self.questionID = questionID
        }
        if let userInLine = dictionary["userInLine"] as? Bool {
            self.userInLine = userInLine
        }
        if let userLinePosition = dictionary["userLinePosition"] as? Int {
            self.userLinePosition = userLinePosition
        }
        if let deviceID = dictionary["deviceID"] as? String {
            self.deviceID = deviceID
        }
        self.dictInfo = dictionary
    }
    
    init(userID: String, username: String, profileType: String, email: String,
         lineNumber: Int, questionID: String, userInLine: Bool, userLinePosition: Int, deviceID: String) {
        self.userID = userID
        self.username = username
        self.profileType = profileType
        self.email = email
        self.questionID = questionID
        self.userInLine = userInLine
        self.userLinePosition = userLinePosition
        self.deviceID = deviceID
        self.dictInfo = [
            "userID": userID,
            "username": username,
            "profileType": profileType,
            "email": email,
            "questionID": questionID,
            "userInLine": userInLine,
            "userLinePosition": userLinePosition,
            "deviceID": deviceID
        ]
    }
    
    func getDictInfo() -> [AnyHashable: Any] {
        return self.dictInfo
    }
}
