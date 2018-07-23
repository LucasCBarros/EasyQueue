//
//  ConfiguracoesController.swift
//  FilaFacil
//
//  Created by Estudante on 23/07/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ConfiguracoesController: UIViewController {

    
    @IBOutlet weak var switchDev: UISwitch!
    @IBOutlet weak var switchDesign: UISwitch!
    @IBOutlet weak var switchBusiness: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
}
