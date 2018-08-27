//
//  UserProfile.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

enum ProfileType: Int {
    case user = 0
    case admin = 1
    
    static let ptDefault: ProfileType = .user
}

class UserProfile: NSObject, PersistenceObject {

    // Users ID
    var userID: String = ""
    
    // Users Name
    var username: String = ""
    
    // Users profile type
    var profileType: ProfileType = ProfileType.user
    
    // Users E-mail
    var email: String = ""
    
    // Users Position in the Line
    var deviceID: String = ""
    
    // Users photo if it has
    var photo: String?
    
    // Date most recent photo update
    var photoModifiedAt: Date?
    
    // Dictionary
    var dictInfo: [AnyHashable: Any]
    
    required init(dictionary: [AnyHashable: Any]) {
        
        if let userID = dictionary["userID"] as? String {
            self.userID = userID
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let profileType = dictionary["profileType"] as? ProfileType {
            self.profileType = profileType
        }
        if let email = dictionary["email"] as? String {
            self.email = email
        }
        if let deviceID = dictionary["deviceID"] as? String {
            self.deviceID = deviceID
        }
        if let photo = dictionary["photo"] as? String {
            self.photo = photo
        }
        if let photoModifiedAt = dictionary["photoModifiedAt"] as? Date {
            self.photoModifiedAt = photoModifiedAt
        }
        
        self.dictInfo = dictionary
    }
    
    init(userID: String, username: String, profileType: ProfileType = ProfileType.ptDefault,
         email: String, deviceID: String, photo: String? = nil, photoModifiedAt: Date? = nil) {
        self.userID = userID
        self.username = username
        self.profileType = profileType
        self.email = email
        self.deviceID = deviceID
        self.photoModifiedAt = photoModifiedAt
        self.dictInfo = [
            "userID": userID,
            "username": username,
            "email": email,
            "deviceID": deviceID,
            "photoModifiedAt": photoModifiedAt
        ]
        if let photo = photo {
            self.photo = photo
            self.dictInfo["photo"] = photo
        }
    }
    
    func getDictInfo() -> [AnyHashable: Any] {
        return self.dictInfo
    }
}
