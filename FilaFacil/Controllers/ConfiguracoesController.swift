//
//  ConfiguracoesController.swift
//  FilaFacil
//
//  Created by Estudante on 23/07/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ConfiguracoesController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var developerSwitch: UISwitch!
    @IBOutlet weak var designSwitch: UISwitch!
    @IBOutlet weak var businessSwitch: UISwitch!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let switchsState = PresentedLinesManager.shared.lines
        
        if switchsState.contains("Developer") {
            self.developerSwitch.setOn(true, animated: false)
        } else {
            self.developerSwitch.setOn(false, animated: false)
        }
        if switchsState.contains("Design") {
            self.designSwitch.setOn(true, animated: false)
        } else {
            self.designSwitch.setOn(false, animated: false)
        }
        if switchsState.contains("Business") {
            self.businessSwitch.setOn(true, animated: false)
        } else {
            self.businessSwitch.setOn(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let selectedLines = PresentedLinesManager.shared.lines
        LineDAO().fetchAllLines { (allLines, _) in
            if let allLines = allLines {
                var lines = allLines.reduce(Set<String>(), { (result, line) in
                    var result = result
                    result.insert(line.name)
                    return result
                })
                for line in selectedLines {
                    lines.remove(line)
                }
                let removedLines = lines.map({ (element) -> CategoryQuestionType? in
                    return CategoryQuestionType(rawValue: element)
                })
                let newLines = selectedLines.map({ (element) -> CategoryQuestionType? in
                    return CategoryQuestionType(rawValue: element)
                })
                
                PushNotifications.removeSubscriptions(categoriesQuestion: removedLines.compactMap({$0}))
                PushNotifications.saveSubscriptions(categoriesQuestion: newLines.compactMap({$0}))
            }
        }
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
    
}
