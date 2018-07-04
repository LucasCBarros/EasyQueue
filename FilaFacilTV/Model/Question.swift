//
//  Question.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 20/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation

struct Question: Equatable {
    
    let questionID: String
    let questionTitle: String
    let categoryQuestion: CategoryQuestion!
    let requestedTeacher: String
    let userID: String
    let username: String
    var userPhoto: String
    
    static func == (lhs: Question, rhs: Question) -> Bool {
        return lhs.questionID == rhs.questionID
    }
    
    static func != (lhs: Question, rhs: Question) -> Bool {
        return !(lhs == rhs)
    }
    
    init(json: [String: Any]) {
        questionID = json["questionID"] as? String ?? "?"
        questionTitle = json["questionTitle"] as? String ?? "??"
        requestedTeacher = json["requestedTeacher"] as? String ?? "???"
        
        switch requestedTeacher {
        case CategoryQuestionType.developer.rawValue:
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.developer)
        case CategoryQuestionType.design.rawValue:
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.design)
        case CategoryQuestionType.business.rawValue:
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.business)
        default:
            categoryQuestion = CategoryQuestion(type: CategoryQuestionType.other)
        }
        
        userID = json["userID"] as? String ?? "????"
        username = json["username"] as? String ?? "?????"
        userPhoto = json["userPhoto"] as? String ?? "?????"
        
    }
}
