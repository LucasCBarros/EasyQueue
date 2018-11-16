//
//  NoteProfile.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

class NoteProfile: NSObject, PersistenceObject {

    // Writen by user
    var noteText: String = ""
    
    // TimeStamp to make ID
    var noteID: String = ""
    
    // UserID from Database
    var userID: String = ""
    
    // Name of the user who created the note
    var username: String = ""
    
    // Date of the note
    var createdAt: Date!
    
    // Dictionary
    var dictInfo: [AnyHashable: Any]

    required init(dictionary: [AnyHashable: Any]) {

        if let noteText = dictionary["noteText"] as? String {
            self.noteText = noteText
        }
        if let noteID = dictionary["recordId"] as? String {
            self.noteID = noteID
        }
        if let username = dictionary["username"] as? String {
            self.username = username
        }
        if let createdAt = dictionary["createdAt"] as? Date {
            self.createdAt = createdAt
        }
        if let userID = dictionary["userId"] as? String {
            self.userID = userID
        }
        self.dictInfo = dictionary
        
    }

    init(noteText: String, noteID: String, userID: String, createdAt: Date, username: String) {
        self.noteText = noteText
        self.noteID = noteID
        self.userID = userID
        self.username = username
        self.createdAt = createdAt
        self.dictInfo = [
            "noteText": noteText,
            "noteID": noteID,
            "userID": userID,
            "createdAt": createdAt]
    }

    func getDictInfo() -> [AnyHashable: Any] {
        return self.dictInfo
    }
}
