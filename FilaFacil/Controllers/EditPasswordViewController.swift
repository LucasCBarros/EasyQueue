//
//  EditPasswordViewController.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 19/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol EditPasswordViewControllerDelegate: NSObjectProtocol {
    func newPassword(_ password: String)
}

class EditPasswordViewController: UIViewController {
    
    open weak var delegate: EditPasswordViewControllerDelegate?
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    let alert = UIAlertController(title: "Senha inválida", message: "Senha deve ter no mínimo 6 caracteres e ser igual a confirmação.", preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    @IBAction func okButton(_ sender: UIBarButtonItem) {
        if let password = passwordTextField.text, password == confirmPasswordTextField.text && password.count > 5 {
            self.delegate?.newPassword(password)
            
            self.navigationController?.popViewController(animated: true)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
