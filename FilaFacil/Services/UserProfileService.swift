//
//  UserProfileService.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class UserProfileService: NSObject {
    
    let userProfileManager = UserProfileDAO()
    
    /// AuthBase functions:
    // Register - Creates new user
    func createUser(userID: String, username: String, profileType: String,
                    email: String, questionID: String) {
        userProfileManager.createUserProfile(userID: userID, username: username,
                                             profileType: profileType, email: email,
                                             questionID: questionID)
    }
    
    // Login - Retrieve user info
    func retrieveUser(userID: String, completionHandler: @escaping (UserProfile?) -> Void) {
        userProfileManager.retrieveUserProfile(userID: userID) { (user) in
            if let currUser = user {
                completionHandler(currUser)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    /// Other functions:
    // Retrieve all users
    func retrieveAllUsersInLine(completion: @escaping ([UserProfile]?) -> Void) {
        userProfileManager.retrieveAllUsersInLine(completionHandler: completion)
    }
    
    // Update user (Field: UserInLine<Bool> and QuestionID<String> and userLinePosition<Int>
    func updateLinePosition(userID: String, position: Int) {
        userProfileManager.updateUserLinePosition(userID: userID, position: position)
    }
    
    // Retrieve Current User
    func retrieveCurrentUserProfile(completion: @escaping (UserProfile?) -> Void) {
        userProfileManager.retrieveCurrentUserProfile(completionHandler: completion)
    }
    
    // Remove LineData from User
    func removeQuestionFromLine(questionID: String) {
        userProfileManager.removeQuestionFromLine(questionID: questionID)
    }
    
    func filterUsersInLine(allUsers: [UserProfile]) -> [UserProfile] {
        var usersInLine: [UserProfile] = []
        for user in allUsers where user.userInLine {
            usersInLine.append(user)
        }
        return usersInLine
    }
    
    func filterLineByTab(allUsers: [UserProfile], allQuestions: [QuestionProfile],
                         selectedTab: String) -> ([UserProfile], [QuestionProfile]) {
        var usersInLine: [UserProfile] = []
        var questionsInLine: [QuestionProfile] = []
        for user in allUsers {
            for question in allQuestions where
                (user.questionID == question.questionID) && (question.requestedTeacher == selectedTab) {
                    usersInLine.append(user)
                    questionsInLine.append(question)
            }
        }
        return (usersInLine, questionsInLine)
    }
}
