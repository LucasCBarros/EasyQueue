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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func loginActionButton(_ sender: UIButton) {
        if let email = emailTextField.text, !email.isEmpty {
            authService.tryLoggin(email: email) { (authenticated, error) in
                if authenticated {
                    DispatchQueue.main.async {
                        self.presentLoggedInScreen()
                    }
                } else if let loginError = error as? LoginError {
                    self.errorHandling(loginError)
                }
            }
        } else {
            let alert = UIAlertController(title: "Email vazio.", message: "Digite seu email.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: {
                self.emailTextField.text = ""
            })
        }
    }
    
    // MARK: - Properties
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.44)])
        
        self.loginButton.layer.cornerRadius = 7
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardFrame.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    override func viewDidAppear(_ animated: Bool) {
        authService.checkUserLogged { (authenticated, error) in
            if authenticated {
                DispatchQueue.main.async {
                    self.presentLoggedInScreen()
                }
            } else {
                if let loginError = error as? LoginError {
                    self.errorHandling(loginError)
                }
            }
        }
    }
    
    // Opens app screens to loggedIn users
    func presentLoggedInScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "TabBarView", bundle: nil)
        let tabBarController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as? UITabBarController
        let appDelegate = UIApplication.shared.delegate as? AppDelegate?
        appDelegate??.window?.rootViewController = tabBarController
    }
    
    fileprivate func errorHandling(_ loginError: LoginError) {
        DispatchQueue.main.async {
            switch loginError {
            case .iCloudNotLoggedInDevice:
                let alert = UIAlertController(title: "iCloud desconectado", message: "Este dispositivo não está logado no iCloud.", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: {
                    self.emailTextField.text = ""
                })
                break
            case .emailDontMatchICloudEmail:
                let alert = UIAlertController(title: "Email inválido", message: "Este email não está vinculado ao seu iCloud.", preferredStyle: .alert)
                self.present(alert, animated: true, completion: {
                    self.emailTextField.text = ""
                })
                break
            case .emailNotRegistered:
                // Nunca vai acontecer aqui. Primeiro acesso do usuário.
                break
            case .emailNotAuthorized:
                
                    self.performSegue(withIdentifier: "accessDeniedSegue", sender: nil)
                break
            }
        }
    }
    
}
