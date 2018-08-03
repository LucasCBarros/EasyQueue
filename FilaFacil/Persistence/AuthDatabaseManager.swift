//
//  AuthDatabaseManager.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
//import FirebaseAuth

// Possible Error Codes
let wrongPassword = 17009
let userNotFound = 17011
let weakPassword = 17026
let emailInUse = 17007

class AuthDatabaseManager: NSObject {
//
//    func signIn(email: String, password: String, completionHandler: @escaping (Bool, String) -> Void) {
//        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
//            
//            if user != nil {
//                print("User logged succesfully")
//                completionHandler(true, (user?.user.uid)!)
//            } else {
//                print("Error on loging in: \(error.debugDescription)")
//                completionHandler(false, self.treatError(error: error! as NSError))
//            }
//        }
//    }
//    
//    // Treat Possible errors from Firebase
//    func treatError(error: NSError) -> String {
//        var message: String
//        
//        switch error.code {
//        case wrongPassword:
//            message = "Wrong password"
//            
//        case userNotFound:
//            message = "User not found"
//            
//        case weakPassword:
//            message = "Weak password. Try one with at least 6 characters"
//            
//        case emailInUse:
//            message = "Email already in use"
//            
//        default:
//            message = String(describing: (error.localizedDescription))
//        }
//        
//        return message
//    }
//    
//    func register(email: String, password: String, completionHandler: @escaping (Bool, String) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
//            if let newUser = user {
//                print("User created succesfully")
//                completionHandler(true, newUser.user.uid)
//            } else {
//                print("Error on register: \(String(describing: (error?.localizedDescription)!))")
//                completionHandler(false, self.treatError(error: error! as NSError))
//            }
//        }
//    }
//    
//    func signOut() {
//        do {
//            try Auth.auth().signOut()
//            
//            print("Logged out successfully")
//        } catch let signOutError as NSError {
//            print ("Error signing out: %@", signOutError)
//        }
//    }
//    
    func checkSignIn() -> Bool {
        if FileManager.default.ubiquityIdentityToken != nil {
            return true
        } else {
            return false
        }
//        if Auth.auth().currentUser != nil {
//            return true
//        } else {
//            return false
//        }
    }
//
//    func retrieveCurrentUserID() -> String {
//        let currentUser = Auth.auth().currentUser
//        
//        if currentUser != nil {
//            return (currentUser?.uid)!
//        } else {
//            print("Error finding current User!")
//            return ""
//        }
//    }
}
