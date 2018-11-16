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
    let userProfileService = UserProfileService.shared
    
    func signOut() {
        //authManager.signOut()
    }
    
    func tryLoggin(email: String, completion: @escaping(Bool, Error?) -> Void) {
        authManager.trySigin(email: email, completion: completion)
    }
    
    //func checkUserLogged() -> Bool {
    func checkUserLogged(completion: @escaping(Bool, Error?) -> Void) {
        //return authManager.checkSignIn()
        authManager.checkSignin { (authenticated, error) in
            completion(authenticated, error)
        }
    }
}
