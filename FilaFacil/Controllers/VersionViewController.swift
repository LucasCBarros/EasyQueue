//
//  VersionViewController.swift
//  FilaFacil
//
//  Created by João Agostinho Hergert on 16/08/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class VersionViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get version from of the app
        if let dict = Bundle.main.infoDictionary {
            
            if let version = dict["CFBundleShortVersionString"] {
                
                //print(version)
                versionLabel.text = "v\(version as? String ?? "0.0.0")"
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
