//
//  QuestionProfileService.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class QuestionProfileService: NSObject {
   
    let questionProfileManager = QuestionProfileDAO()
    
    // Returns the question associated with the current User
    func retrieveUsersQuestion(questionID: String, completion: @escaping (QuestionProfile?) -> Void) {
       questionProfileManager.retrieveUsersQuestion(questionID: questionID, completionHandler: completion)
    }
    
    func retrieveCurrentQuestion(questionID: String, completion: @escaping (QuestionProfile?) -> Void) {
        questionProfileManager.retrieveCurrentQuestion(questionID: questionID, completionHandler: completion)
    }
    
    // Remove LineData from User
    func removeQuestionFromLine(lineName: String, question: QuestionProfile, completionHandler: @escaping (Error?) -> Void) {
        questionProfileManager.removeQuestionFromLine(question: question, completionHandler: {(error) in
            
            completionHandler(error)
        })
    }

    ///:BAD CODE - Will retrieve all questions
    // Return all open questions
    func retrieveAllOpenQuestions(lineName: String, completion: @escaping ([QuestionProfile]?) -> Void) {
        questionProfileManager.retrieveAllOpenQuestions(lineName: lineName, completionHandler: {(allQuestions)  in
            var filteredQuestions = allQuestions?.filter({ (question) -> Bool in
                return question.requestedTeacher == lineName
            })
            
            if let questions = filteredQuestions {
                filteredQuestions = questions.sorted{ $0.createdAt < $1.createdAt }
            }
            
            completion(filteredQuestions)
        })
    }
    
    // Create a question
    func createQuestion(user: UserProfile, questionTxt: String, requestedTeacher: String) {
        questionProfileManager.createQuestion(user: user,
                                              questionTxt: questionTxt,
                                              requestedTeacher: requestedTeacher)
    }
}
