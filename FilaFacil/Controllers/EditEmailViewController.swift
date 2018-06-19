//
//  EditEmailViewController.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 19/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol EditEmailViewControllerDelegate: NSObjectProtocol {
    
    func newEmail(_ email: String)
    
}

class EditEmailViewController: UIViewController {
    
    open weak var delegate: EditEmailViewControllerDelegate?
    @IBOutlet weak var emailTextField: UITextField!
    let alert = UIAlertController(title: "Email inválido", message: nil, preferredStyle: UIAlertControllerStyle.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    @IBAction func okButton(_ sender: UIBarButtonItem) {
        if let email = emailTextField.text, email.count > 5 {
            self.delegate?.newEmail(email)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
