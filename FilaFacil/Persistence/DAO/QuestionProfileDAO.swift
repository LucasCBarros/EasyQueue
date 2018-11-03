//
//  QuestionProfileDAO.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import CloudKit

class QuestionProfileDAO: DAO {
    
    // Return all open questions
    func retrieveAllOpenQuestions(completionHandler: @escaping ([QuestionProfile]?) -> Void) {
    
        self.retrieveAll(dump: QuestionProfile.self, path: "Question") { (questions) in
            completionHandler(questions)
        }
    }
    
    // Create a question
    func createQuestion(user: UserProfile, questionTxt: String, requestedTeacher: String) {
        
        let record = CKRecord(recordType: "Question")
        
        record.setObject(user.userID as CKRecordValue, forKey: "userID")
        record.setObject(questionTxt as CKRecordValue, forKey: "questionTitle")
        record.setObject(user.username as CKRecordValue, forKey: "username")
        record.setObject(requestedTeacher as CKRecordValue, forKey: "requestedTeacher")
        if let photoModifiedAt = user.photoModifiedAt {
            record.setObject(photoModifiedAt as CKRecordValue, forKey: "photoModifiedAt")
        }
        
        publicDB.save(record, completionHandler: { record, error in
            
            guard let record = record else {
                print("Error saving record: ", error as Any)
                return
            }
            
            print("Successfully saved record: ", record)

        })
    }
    
    func removeQuestionFromLine(question: QuestionProfile, completionHandler: @escaping((Error?) -> Void)) {

        let questionId = CKRecord.ID(recordName: question.questionID)
        
        publicDB.delete(withRecordID: questionId) { (record, error) in
            
            if let error = error {
                print("Error deleting record: ", error as Any)
                //return
                completionHandler(error)
                
            }
            
            print("Successfully deleted record: ", record as Any)
        }
    }
}
