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
    
    static public let shared = UserProfileService()
    
    private override init() { }
    
    let userProfileManager = UserProfileDAO()
    
    private var currentUser: UserProfile?
    
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
    
    func retrieveImage(for userId: String, modifiedAt date: Date?, with completionHandler: @escaping (UIImage?, Bool, Error?) -> Void) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let cacheDate = CacheManager.shared.retrieveLastModificationDate(for: userId),
                let date = date, cacheDate >= date,
                let image = CacheManager.shared.retrieveImage(for: userId) {
                completionHandler(image, false, nil)
            } else {
                self.userProfileManager.retrieveImage(for: userId, with: { (data, date, error) in
                    if let data = data, let date = date, error == nil {
                        // TODO: pensar em forma de tratar data da imagem de forma eficiente.
                        CacheManager.shared.save(data: data, with: date, in: userId)
                        completionHandler(UIImage(data: data), true, error)
                    }
                    completionHandler(nil, true, error)
                })
            }
        }
    }
    
    func saveImage(_ image: Data, for user: UserProfile, with completionHandler: @escaping (UserProfile?, Error?) -> Void) {
        self.userProfileManager.saveImage(image, for: user) { (newUser, error) in
            if error == nil {
                CacheManager.shared.save(data: image, with: Date(), in: user.userID)
                completionHandler(newUser, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    func editUsername(user: UserProfile, completion: @escaping (UserProfile, Error?) -> Void) {
        
        userProfileManager.editUsername(user: user) { (user, error) in
            if error == nil {
                self.currentUser = user
                completion(user, error)
            }
        }
    }
    
    // Retrieve Current User
    func retrieveCurrentUserProfile(completion: @escaping (UserProfile?) -> Void) {
        
        if self.currentUser == nil {
            userProfileManager.retrieveCurrentUserProfile { (userProfile) in
                self.currentUser = userProfile
                completion(self.currentUser)
            }
        } else {
            completion(self.currentUser)
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
