//
//  QuestionProfile.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class QuestionProfile: NSObject, PersistenceObject {

    // Writen by user
    var questionTitle: String = ""
    
    // TimeStamp to make ID
    var questionID: String = ""
    
    // UserID from Firebase
    var userID: String = ""
    
    // Username from Firebase
    var username: String = ""
    
    // Empty or one of the existing
    var requestedTeacher: String = ""
    
    // Dictionary
    var dictInfo: [AnyHashable: Any]
    
    required init(dictionary: [AnyHashable: Any]) {
        
        if let questionTitle = dictionary["questionTitle"] as? String {
            self.questionTitle = questionTitle
        }
        if let questionID = dictionary["questionID"] as? String {
            self.questionID = questionID
        }
        if let userID = dictionary["userID"] as? String {
            self.userID = userID
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let requestedTeacher = dictionary["requestedTeacher"] as? String {
            self.requestedTeacher = requestedTeacher
        }
        self.dictInfo = dictionary
    }
    
    init(questionTitle: String, questionID: String, userID: String, username: String, requestedTeacher: String) {
        self.questionTitle = questionTitle
        self.questionID = questionID
        self.userID = userID
        self.username = username
        self.requestedTeacher = requestedTeacher
        self.dictInfo = [
            "questionTitle": questionTitle,
            "questionID": questionID,
            "userID": userID,
            "username": username,
            "requestedTeacher": requestedTeacher
        ]
    }
    
    func getDictInfo() -> [AnyHashable: Any] {
        return self.dictInfo
    }
}
