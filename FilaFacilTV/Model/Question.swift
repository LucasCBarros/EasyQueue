//
//  Question.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 20/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

struct Question: Equatable{
    static func ==(lhs: Question, rhs: Question) -> Bool {
        return lhs.questionID == rhs.questionID
    }
    
    let questionID: String
    let questionTitle: String
    let categoryQuestion: CategoryQuestion!
    let requestedTeacher: String
    let userID: String
    let username: String
    
    init(json: [String: Any]) {
        questionID = json["questionID"] as? String ?? "?"
        questionTitle = json["questionTitle"] as? String ?? "??"
        requestedTeacher = json["requestedTeacher"] as? String ?? "???"
        
        //TODO: Esse parce está na camada errada?
        switch requestedTeacher {
        case "Dev":
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.developer)
        case "Design":
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.design)
        case "Bisness":
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.business)
        default:
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.developer)
        }
        
        userID = json["userID"] as? String ?? "????"
        username = json["username"] as? String ?? "?????"
    }
}
