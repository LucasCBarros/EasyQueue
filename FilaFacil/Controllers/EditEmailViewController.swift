//
//  EditEmailViewController.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 19/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol EditEmailViewControllerDelegate: NSObjectProtocol {
    func change(username: String)
}

class EditEmailViewController: MyViewController {
    
    open weak var delegate: EditEmailViewControllerDelegate?
    @IBOutlet weak var usernameTextField: UITextField!
    
    let alert = UIAlertController(title: "Username inválido", message: nil, preferredStyle: UIAlertController.Style.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholder = "Novo username"
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
    
    @IBAction func okButton(_ sender: UIBarButtonItem) {
        if let username = usernameTextField.text, username.count > 1 {
            self.delegate?.change(username: username)
            self.navigationController?.popViewController(animated: true)
        } else {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
