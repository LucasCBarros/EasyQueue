//
//  LoginViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class LoginViewController: MyViewController {

    // MARK: - Outlets
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var usernameTxtField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    // MARK: - Properties
    let authService = AuthService()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        emailTxtField.textColor = UIColor.white
//        emailTxtField.attributedPlaceholder = NSAttributedString(string: "E-mail",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        passwordTxtField.textColor = UIColor.white
//        passwordTxtField.attributedPlaceholder = NSAttributedString(string: "Password",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        usernameTxtField.textColor = UIColor.white
//        usernameTxtField.attributedPlaceholder = NSAttributedString(string: "Username",
//                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        registerBtn.clipsToBounds = true
//        registerBtn.layer.cornerRadius = 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        authService.checkUserLogged { (authenticated) in
            if authenticated {
                DispatchQueue.main.async {
                    self.presentLoggedInScreen()
                }
            } else {
                DispatchQueue.main.async {
                    self.authService.signOut()
                }
            }
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//        authService.checkUserLogged { (authenticated) in
//            if authenticated {
//                self.presentLoggedInScreen()
//            } else {
//                self.authService.signOut()
//            }
//        }
//    }
    
    // Creates a new Account in FB
    @IBAction func click_createAccount(_ sender: Any) {
        createAccount()
    }
    
    // MARK: - Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createAccount() {
        /// Check empty fields
        if (usernameTxtField.text?.isEmpty)! {
            self.alertMessage(title: "Register Error", message: "Name field can't be empty")
        }
        if (emailTxtField.text?.isEmpty)! {
            self.alertMessage(title: "Register Error", message: "Email field can't be empty!")
        }
        if (passwordTxtField.text?.isEmpty)! {
            self.alertMessage(title: "Register Error", message: "Password field can't be empty")
        }
        
        guard let email = emailTxtField.text else {
//            self.alertMessage(title: "Register Error", message: "Email field can't be empty!")
            print("Email Error!")
            return
        }
        guard let password = passwordTxtField.text else {
//            self.alertMessage(title: "Register Error", message: "Password field can't be empty")
            print("Password Error!")
            return
        }
        guard let username = usernameTxtField.text else {
//            self.alertMessage(title: "Register Error", message: "Name field can't be empty")
            print("Name Error!")
            return
        }
        
        // Register the user and perform a Loggedin Segue
        authService.register(email: email, password: password, username: username) { (success, idOrErrorMessage) in
            if success {
                self.performSegue(withIdentifier: "LoggedIn", sender: nil)
            } else {
                self.alertMessage(title: "Register Error", message: idOrErrorMessage)
                print("Problem to register")
            }
        }
    }

//    func login() {
//        // Check if fields are empty
//        if let email = emailTxtField.text, let password = passwordTxtField.text {
//            
//            // Autenticates and finds Existing user
//            authService.login(email: email, password: password, completionHandler: { (user) in
//                if user != nil {
//                    self.presentLoggedInScreen()
//                    
//                } else {
//                    // Alert User not found!
//                    self.alertMessage(title: "Login Error", message: "Coulden't Find user!")
//                    print("Coulden't Find user!")
//                }
//            })
//            // Treat empty field problem
//        } else {
//            self.alertMessage(title: "Login Error", message: "Both email and password can't be empty")
//            print("Problem in login")
//        }
//    }
    
//    func isUserSignedIn() -> Bool {
//        return authService.checkUserLogged()
//    }
    
    // Alert message case error
    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // Opens app screens to loggedIn users
    func presentLoggedInScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "TabBarView", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate?
        appDelegate??.window?.rootViewController = tabBarController
    }
}
