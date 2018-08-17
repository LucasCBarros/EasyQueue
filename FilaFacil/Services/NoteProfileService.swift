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
    
    func retrieveOrderedNotes(completion: @escaping ([NoteProfile]?) -> Void) {
       
        retrieveAllOpenNotes { (allNotes) in
            completion(allNotes?.sorted { $0.createdAt < $1.createdAt })
        }
    }
    
    // Create a question
    func createNote(userID: String, username: String, noteText: String, completion: @escaping(Error?) -> Void) {
        noteProfileManager.createNote(userID: userID, username: username, noteText: noteText, completionHandler: {(error) in
            completion(error)
        })
    }
    
    // Remove note
    func removeNote(note: NoteProfile, completion: @escaping (Error?) -> Void) {
        noteProfileManager.removeNote(note: note, completionHandler: {error in
            completion(error)
        })
    }
}
