//
//  EditEmailViewController.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 19/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol EditEmailViewControllerDelegate: NSObjectProtocol {
    func change(email: String, _ password: String)
}

class EditEmailViewController: UIViewController {
    
    open weak var delegate: EditEmailViewControllerDelegate?
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    let alert = UIAlertController(title: "Email inválido", message: nil, preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    @IBAction func okButton(_ sender: UIBarButtonItem) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.count > 5 {
            self.delegate?.change(email: email, password)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
