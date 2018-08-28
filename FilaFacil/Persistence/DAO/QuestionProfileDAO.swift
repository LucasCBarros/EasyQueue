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
    
    // Returns the question associated with the current User
    func retrieveUsersQuestion(questionID: String, completionHandler: @escaping (QuestionProfile?) -> Void) {
//        let path = "Questions/\(questionID)"
//
//        self.retrieveAll(dump: QuestionProfile.self, path: path) { (question) in
//            completionHandler(question?.first)
//        }
    }
    
    func retrieveQuestionByID(questionID: String, completionHandler: @escaping (QuestionProfile?) -> Void) {
//        let path = "Questions/\(questionID)"
//        
//        self.retrieveByID(dump: QuestionProfile.self, path: path) { (question) in
//            completionHandler(question?.first)
//        }
    }

    // Retrieve Current User
    func retrieveCurrentQuestion(questionID: String, completionHandler: @escaping (QuestionProfile?) -> Void) {
        
//        ref?.child("Questions/\(questionID)").observeSingleEvent(of: .value, with: { (snapshot) in
//            let user = snapshot.value as? NSDictionary
//
//            if let actualUser = user {
//
//                let newUser = QuestionProfile(dictionary: (actualUser as? [AnyHashable: Any])!)
//
//                completionHandler(newUser)
//            } else {
//                completionHandler(nil)
//            }
//        })
    }
    
    // Return all open questions
    func retrieveAllOpenQuestions(lineName: String, completionHandler: @escaping ([QuestionProfile]?) -> Void) {
    
        self.retrieveAll(dump: QuestionProfile.self, path: "Question") { (questions) in
            completionHandler(questions)
        }
    }
    
    // Create a question
    func createQuestion(user: UserProfile, questionTxt: String, requestedTeacher: String) {
        
//        let uuid = UUID().uuidString
//
//        let timeStampID = "\(Date().millisecondsSince1970)"
//
//        let noteID = CKRecordID(recordName: uuid)
        
//        let record = CKRecord(recordType: "Question", recordID: noteID)
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

        let questionId = CKRecordID(recordName: question.questionID)
        
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
