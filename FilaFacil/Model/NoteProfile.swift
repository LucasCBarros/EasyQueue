//
//  NoteProfile.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NoteProfile: NSObject, PersistenceObject {

    // Writen by user
    var noteText: String = ""
    
    // TimeStamp to make ID
    var noteID: String = ""
    
    // UserID from Firebase
    var userID: String = ""
    
    // Dictionary
    var dictInfo: [AnyHashable: Any]

    required init(dictionary: [AnyHashable: Any]) {

        if let noteText = dictionary["noteText"] as? String {
            self.noteText = noteText
        }
        if let noteID = dictionary["noteID"] as? String {
            self.noteID = noteID
        }
        if let userID = dictionary["userID"] as? String {
            self.userID = userID
        }
        self.dictInfo = dictionary
    }

    init(noteText: String, noteID: String, userID: String) {
        self.noteText = noteText
        self.noteID = noteID
        self.userID = userID
        self.dictInfo = [
            "noteText": noteText,
            "noteID": noteID,
            "userID": userID ]
    }

    func getDictInfo() -> [AnyHashable: Any] {
        return self.dictInfo
    }
}
