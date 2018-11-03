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
    
    func checkUserLogged(completion: @escaping(Bool) -> Void) {
        authManager.checkSignIn { (authenticated) in
            completion(authenticated)
        }
    }
}
