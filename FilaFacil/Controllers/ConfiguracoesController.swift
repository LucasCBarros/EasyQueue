//
//  ConfiguracoesController.swift
//  FilaFacil
//
//  Created by Estudante on 23/07/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ConfiguracoesController: UITableViewController {
    
    @IBOutlet weak var developerSwitch: UISwitch!
    @IBOutlet weak var designerSwitch: UISwitch!
    @IBOutlet weak var businessSwitch: UISwitch!
    
    @IBAction func switchDeveloperAction(_ sender: UISwitch) {
        if sender.isOn {
            PresentedLinesService.shared.add("Developer")
        } else {
            PresentedLinesService.shared.remove("Developer")
        }
    }
    @IBAction func switchDesignerAction(_ sender: UISwitch) {
        if sender.isOn {
            PresentedLinesService.shared.add("Designer")
        } else {
            PresentedLinesService.shared.remove("Designer")
        }
    }
    @IBAction func switchBusinessAction(_ sender: UISwitch) {
        if sender.isOn {
            PresentedLinesService.shared.add("Business")
        } else {
            PresentedLinesService.shared.remove("Business")
        }
    }
    
    //Leva para Notificações em configurações
    @IBAction func goNotification(_ sender: UIButton) {
        
        guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundView = UIImageView(image: #imageLiteral(resourceName: "background-notes"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 3) {
            cell.separatorInset = UIEdgeInsets(top: 0.0, left: cell.bounds.size.width, bottom: 0.0, right: 0.0)
        }
    }
    
    //Cuida do switch das filas
    func handleLines() {
        
    }
    
}
