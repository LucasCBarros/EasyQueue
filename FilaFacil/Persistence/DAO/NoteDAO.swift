//
//  NoteDAO.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NoteDAO: DAO {
    
    // Return all open notes
    func retrieveAllOpenNotes(completionHandler: @escaping ([NoteProfile]?) -> Void) {
        let path = "Notes/"
        
        self.retrieveAll(dump: NoteProfile.self, path: path) { (notes) in
            completionHandler(notes)
        }
    }
    
    // Create a note
    func createNote(userID: String, noteText: String ) {
        
        let path = "Notes/"
        
        let newNoteData = [userID,
                           noteText]
        
        let noteFields = ["userID",
                          "noteText"]
        
        let timeStampID = "\(Date().millisecondsSince1970)"
        let pathWithID = path + timeStampID
        
        for note in 0..<noteFields.count {
            ref?.child(pathWithID).child(noteFields[note]).setValue(newNoteData[note])
        }
        
        ref?.child(pathWithID).child("noteID").setValue(timeStampID)
        
        ref?.child("Users").child(userID).child("noteID").setValue(timeStampID)
    }
    
    // Remove note from DB
    func removeNote(noteID: String) {
        ref?.child("Notes").child(noteID).removeValue()
    }
}
