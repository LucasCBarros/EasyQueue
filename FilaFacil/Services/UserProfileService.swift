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
    
    // MARK: - AuthBase functions:
    // Register - Creates new user
    func createUser(userID: String, username: String, email: String, deviceID: String) {
        userProfileManager.createUserProfile(userID: userID, username: username, email: email, deviceID: deviceID)
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
    
    // MARK: - Other functions:
    // Retrieve Current User
    func retrieveCurrentUserProfile(completion: @escaping (UserProfile?) -> Void) {
        userProfileManager.retrieveCurrentUserProfile(completionHandler: completion)
    }
    
    // Remove LineData from User
    func removeQuestionFromLine(lineName: String, questionID: String) {
        userProfileManager.removeQuestionFromLine(lineName: lineName, questionID: questionID)
    }
    
    func updateTokenID(user: UserProfile) {
        if let deviceID = UserDefaults.standard.string(forKey: "userDeviceID") {
            user.deviceID = deviceID
            userProfileManager.editUser(user: user)
        }
    }
    
    func filterLineByTab(allQuestions: [QuestionProfile], selectedTab: String) -> ([QuestionProfile]) {
        var questionsInLine: [QuestionProfile] = []
        for question in allQuestions where (question.requestedTeacher == selectedTab) {
                questionsInLine.append(question)
        }
        return questionsInLine
    }
}
