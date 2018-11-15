//
//  AccessDeniedViewController.swift
//  FilaFacil
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 15/11/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import MessageUI

class AccessDeniedViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let email = "filafacilcontato@gmail.com"
    
    @IBAction func contactActionButton(_ sender: UIButton) {
        if !MFMailComposeViewController.canSendMail() {
            print("Mail services are not available")
            let alert = UIAlertController(title: "Ops!", message: "Não há e-mail configurado em seu device!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients([self.email])
        composeVC.setSubject("Acesso negado no Fila Fácil.")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
