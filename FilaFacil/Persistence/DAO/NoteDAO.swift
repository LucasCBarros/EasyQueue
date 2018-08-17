//
//  NoteDAO.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit

class NoteDAO: DAO {
    
    // Return all open notes
    func retrieveAllOpenNotes(completionHandler: @escaping ([NoteProfile]?) -> Void) {
        let path = "Note"
        
        self.retrieveAll(dump: NoteProfile.self, path: path) { (notes) in
            completionHandler(notes)
        }
    }
    
    // Create a note
    func createNote(userID: String, username: String, noteText: String, completionHandler: @escaping(Error?) -> Void) {
        
        let uuid = UUID().uuidString

        let noteID = CKRecordID(recordName: uuid)
        
        let record = CKRecord(recordType: "Note", recordID: noteID)
        
        record.setObject(userID as CKRecordValue, forKey: "userId")
        record.setObject(noteText as CKRecordValue, forKey: "noteText")
        record.setObject(username as CKRecordValue, forKey: "username")
        
        publicDB.save(record, completionHandler: { record, error in
            
            guard let record = record else {
                print("Error saving record: ", error as Any)
                return
            }
            
            print("Successfully saved record: ", record)
            completionHandler(error)
        })
    }
    
    // Remove note from DB
    func removeNote(note: NoteProfile, completionHandler: @escaping(Error?) -> Void) {
        
        let noteRecordId = CKRecordID(recordName: note.noteID)

        publicDB.delete(withRecordID: noteRecordId) { (record, error) in
           
            guard let record = record else {
                print("Error deleting record: ", error as Any)
                return
            }
            
            print("Successfully deleted record: ", record)
            completionHandler(error)
        }
    }
}
