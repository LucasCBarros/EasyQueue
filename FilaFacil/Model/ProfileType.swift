//
//  AdminProfile.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 25/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation
import CloudKit

class ProfileType: NSObject, PersistenceObject {
    
    let userID: String
    let userName: String
    var profileType: String
    
    init(userID: String, userName: String, profileType: String) {
        self.userName = userName
        self.userID = userID
        self.profileType = profileType
    }
    
    required init(dictionary: [AnyHashable: Any], recordID: CKRecordID) {
        self.userID = dictionary["userID"] as? String ?? "Error"
        self.userName = dictionary["userName"] as? String ?? "Error"
        self.profileType = dictionary["profileType"] as? String ?? "Error"
    }
    
    func getDictInfo() -> [AnyHashable: Any] {
        var dictionary: [AnyHashable: Any] = [:]
        
        dictionary["userID"] = self.userID
        dictionary["userName"] = self.userName
        dictionary["profileType"] = self.profileType
        
        return dictionary
    }

}
