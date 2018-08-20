//
//  UserProfileService.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation
import Kingfisher

class UserProfileService: NSObject {
    
    let userProfileManager = UserProfileDAO()
    
    /// AuthBase functions:
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
    
    /// Other functions:
    
    func retrieveImage(for userId: String, with completionHandler: @escaping (Data?, Error?) -> Void) {
        if let image = CacheManager.shared.retrieveData(for: userId) {
            completionHandler(image, nil)
        } else {
            self.userProfileManager.retrieveImage(for: userId, with: { (data, error) in
                if let data = data, error == nil {
                    // TODO: pensar em forma de tratar data da imagem de forma eficiente.
                    CacheManager.shared.save(data: data, with: Date(), in: userId)
                }
            })
        }
    }
    
    func saveImage(_ image: Data, for userId: String, with completionHandler: @escaping (Error?) -> Void) {
        self.userProfileManager.saveImage(image, for: userId) { (error) in
            if error != nil {
                CacheManager.shared.save(data: image, with: Date(), in: userId)
                completionHandler(nil)
            } else {
                completionHandler(error)
            }
        }
    }
    
    // Retrieve Current User
    func retrieveCurrentUserProfile(completion: @escaping (UserProfile?) -> Void) {
        userProfileManager.retrieveCurrentUserProfile(completionHandler: completion)
    }
    
    func attualizeTokenID(user: UserProfile) {
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
