//
//  NoteProfileService.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NoteProfileService: NSObject {

    let noteProfileManager = NoteDAO()
    
    // Return all open notes
    func retrieveAllOpenNotes(completion: @escaping ([NoteProfile]?) -> Void) {
        noteProfileManager.retrieveAllOpenNotes(completionHandler: completion)
    }
    
    // Create a question
    func createNote(userID: String, noteText: String) {
        noteProfileManager.createNote(userID: userID, noteText: noteText)
    }
    
    // Remove note
    func removeNote(note: NoteProfile, completion: @escaping (Error?) -> Void) {
        noteProfileManager.removeNote(note: note, completionHandler: {error in
            completion(error)
        })
    }
}
