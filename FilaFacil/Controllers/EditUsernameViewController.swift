//
//  EditEmailViewController.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 19/06/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol EditUsernameViewControllerDelegate: NSObjectProtocol {
    func change(username: String)
}

class EditUsernameViewController: MyViewController {
    
    open weak var delegate: EditUsernameViewControllerDelegate?
    @IBOutlet weak var usernameTextField: UITextField!
    
    let alert = UIAlertController(title: "Apelido inválido", message: nil, preferredStyle: UIAlertController.Style.alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.placeholder = "Novo apelido"
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
