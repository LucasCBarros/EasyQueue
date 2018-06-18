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
    
    ///:BAD CODE - Will retrieve all questions
    // Return all open questions
    func retrieveAllOpenQuestions(completion: @escaping ([QuestionProfile]?) -> Void) {
       questionProfileManager.retrieveAllOpenQuestions(completionHandler: completion)
    }
    
    // Create a question
    func createQuestion(userID: String, questionTxt: String, username: String, requestedTeacher: String, userPhoto: String) {
        questionProfileManager.createQuestion(userID: userID,
                                              questionTxt: questionTxt,
                                              username: username,
                                              requestedTeacher: requestedTeacher,
                                              userPhoto: userPhoto)
    }
    
    func filterQuestionsInLine(allUsers: [UserProfile], allQuestions: [QuestionProfile]) -> [QuestionProfile] {
        var questionsInLine: [QuestionProfile] = []
        for user in allUsers {
            for question in allQuestions where user.questionID == question.questionID {
                questionsInLine.append(question) //.append(question)
            }
        }
        return questionsInLine
    }
}
