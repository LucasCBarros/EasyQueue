//
//  EditPasswordViewController.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 19/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol EditPasswordViewControllerDelegate: NSObjectProtocol {
    func change(password: String, to newPassword: String)
}

class EditPasswordViewController: MyViewController {
    
    open weak var delegate: EditPasswordViewControllerDelegate?
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    let alert = UIAlertController(
        title: "Senha inválida",
        message: "Senha deve ter no mínimo 6 caracteres e ser igual a confirmação.",
        preferredStyle: UIAlertController.Style.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    @IBAction func okButton(_ sender: UIBarButtonItem) {
        if let newPassword = newPasswordTextField.text,
            let password = passwordTextField.text,
            newPassword == confirmPasswordTextField.text && password.count > 5 {
            self.delegate?.change(password: password, to: newPassword)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
