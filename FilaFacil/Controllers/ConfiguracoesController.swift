//
//  ConfiguracoesController.swift
//  FilaFacil
//
//  Created by Estudante on 23/07/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import MessageUI

class ConfiguracoesController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var developerSwitch: UISwitch!
    @IBOutlet weak var designSwitch: UISwitch!
    @IBOutlet weak var businessSwitch: UISwitch!
    var email = "filafacilcontato@gmail.com"
    
    private var initialLines: Set<String> = []
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initialLines = PresentedLinesManager.shared.lines
        
        if initialLines.contains("Developer") {
            self.developerSwitch.setOn(true, animated: false)
        } else {
            self.developerSwitch.setOn(false, animated: false)
        }
        if initialLines.contains("Design") {
            self.designSwitch.setOn(true, animated: false)
        } else {
            self.designSwitch.setOn(false, animated: false)
        }
        if initialLines.contains("Business") {
            self.businessSwitch.setOn(true, animated: false)
        } else {
            self.businessSwitch.setOn(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Add new Categories Question in Push Notification.
        let willAddLines = PresentedLinesManager.shared.lines.subtracting(self.initialLines)
        
        var willAddCategoriesQuestion = [CategoryQuestionType]()
        for line in willAddLines {
            if let categorieQuestion = CategoryQuestionType.init(rawValue: line) {
                willAddCategoriesQuestion.append(categorieQuestion)
            }
        }
        PushNotifications.saveSubscriptions(categoriesQuestion: willAddCategoriesQuestion)
        
        // Remove old Categories Question in Push Notification.
        self.initialLines.subtract(PresentedLinesManager.shared.lines)
        
        var willRemoveCategoriesQuestion = [CategoryQuestionType]()
        for line in self.initialLines {
            if let categorieQuestion = CategoryQuestionType.init(rawValue: line) {
                willRemoveCategoriesQuestion.append(categorieQuestion)
            }
        }
        PushNotifications.removeSubscriptions(categoriesQuestion: willRemoveCategoriesQuestion)
    }
    
    // MARK: - Actions
    @IBAction func switchDeveloperAction(_ sender: UISwitch) {
        if sender.isOn {
            PresentedLinesManager.shared.add("Developer")
        } else {
            PresentedLinesManager.shared.remove("Developer")
        }
    }
    @IBAction func switchDesignAction(_ sender: UISwitch) {
        if sender.isOn {
            PresentedLinesManager.shared.add("Design")
        } else {
            PresentedLinesManager.shared.remove("Design")
        }
    }
    @IBAction func switchBusinessAction(_ sender: UISwitch) {
        if sender.isOn {
            PresentedLinesManager.shared.add("Business")
        } else {
            PresentedLinesManager.shared.remove("Business")
        }
    }
    
    @IBAction func sendFeedback(_ sender: Any) {
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
        composeVC.setSubject("Feedback sobre o aplicativo")
        composeVC.setMessageBody("", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
       
    }
    
    //Leva para Notificações em configurações
    @IBAction func goNotification(_ sender: UIButton) {
        
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
        
    }
    
    // MARK: - Methods
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 3) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
