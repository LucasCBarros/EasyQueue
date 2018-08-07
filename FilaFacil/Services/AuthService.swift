//
//  AuthService.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class AuthService: NSObject {

    let authManager = AuthDatabaseManager()
    let userProfileService = UserProfileService()
    
    func login(email: String, password: String, completionHandler: @escaping (UserProfile?) -> Void) {
//        authManager.signIn(email: email, password: password) {[weak self] (success, idOrErrorMessage) in
//            if success {
//                self?.userProfileService.retrieveUser(userID: idOrErrorMessage, completionHandler: { (user) in
//                    if let currUser = user {
//                        completionHandler(currUser)
//                    } else {
//                        print("Error on login")
//                    }
//                })
//
//            } else {
//                completionHandler(nil)
//            }
//        }

    }
    
    func register(email: String, password: String, username: String, completionHandler: @escaping (Bool, String) -> Void) {
        authManager.register(email: email, username: username) { (success, idOrErrorMessage) in

            if success {
                self.userProfileService.createUser(userID: idOrErrorMessage,
                                                   username: username,
                                                   email: email, deviceID: UserDefaults.standard.string(forKey: "userDeviceID") ?? "")
                completionHandler(true, "")
            } else {
                completionHandler(false, idOrErrorMessage)
            }
        }
    }
    
    func signOut() {
        //authManager.signOut()
    }
    
    //func checkUserLogged() -> Bool {
    func checkUserLogged(completion: @escaping(Bool) -> Void) {
       //return authManager.checkSignIn()
        authManager.checkSignIn { (authenticated) in
            completion(authenticated)
        }
    }
}
