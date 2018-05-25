//
//  QuestionProfileDAO.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class QuestionProfileDAO: DAO {
    
    // Returns the question associated with the current User
    func retrieveUsersQuestion(questionID: String, completionHandler: @escaping (QuestionProfile?) -> Void) {
        let path = "Questions/\(questionID)"
        
        self.retrieveAll(dump: QuestionProfile.self, path: path) { (question) in
            completionHandler(question?.first)
        }
    }
    
    func retrieveQuestionByID(questionID: String, completionHandler: @escaping (QuestionProfile?) -> Void) {
        let path = "Questions/\(questionID)"
        
        self.retrieveByID(dump: QuestionProfile.self, path: path) { (question) in
            completionHandler(question?.first)
        }
    }

    // Retrieve Current User
    func retrieveCurrentQuestion(questionID: String, completionHandler: @escaping (QuestionProfile?) -> Void) {
        
        ref?.child("Questions/\(questionID)").observeSingleEvent(of: .value, with: { (snapshot) in
            let user = snapshot.value as? NSDictionary
            
            if let actualUser = user {
                
                let newUser = QuestionProfile(dictionary: (actualUser as? [AnyHashable: Any])!)
                
                completionHandler(newUser)
            } else {
                completionHandler(nil)
            }
        })
    }
    
    // Return all open questions
    func retrieveAllOpenQuestions(completionHandler: @escaping ([QuestionProfile]?) -> Void) {
        let path = "Questions/"
        
        self.retrieveAll(dump: QuestionProfile.self, path: path) { (questions) in
            completionHandler(questions)
        }
    }
    
    // Create a question
    func createQuestion(userID: String, questionTxt: String, username: String, requestedTeacher: String, positionInLine: Int) {
        
        let path = "Questions/"
        
        let newQuestionData = [userID,
                               questionTxt,
                               username,
                               requestedTeacher]
        
        let questionFields = ["userID",
                            "questionTitle",
                            "username",
                            "requestedTeacher"]
        
        let timeStampID = "\(Date().millisecondsSince1970)"
        let pathWithID = path + timeStampID
        
        for question in 0..<questionFields.count {
            ref?.child(pathWithID).child(questionFields[question]).setValue(newQuestionData[question])
        }
        
        ref?.child(pathWithID).child("questionID").setValue(timeStampID)
        
        ref?.child("Users").child(userID).child("questionID").setValue(timeStampID)
        ref?.child("Users").child(userID).child("userLinePosition").setValue(positionInLine)
        ref?.child("Users").child(userID).child("userInLine").setValue(true)
    }
}
