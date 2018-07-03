//
//  DetailInterfaceController.swift
//  FilaFacilWatch Extension
//
//  Created by Lucas Barros on 19/06/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation
import WatchKit

class DetailInterfaceController: InterfaceController {
    
    @IBOutlet var topPanelBG: WKInterfaceGroup!
    @IBOutlet var questionDescription: WKInterfaceLabel!
    @IBOutlet var usernameLabel: WKInterfaceLabel!
    @IBOutlet var userPhoto: WKInterfaceImage!
    @IBOutlet var startButton: WKInterfaceButton!
    @IBOutlet var actionGroup: WKInterfaceGroup!
    
    var openedQuestion: Question!
    
    @IBAction func startAction() {
        if WatchTimer.startTime == nil {
            WatchTimer.startTime = Date().timeIntervalSince1970
            startButton.setBackgroundColor(#colorLiteral(red: 0.4352941176, green: 0.02352941176, blue: 0.02352941176, alpha: 1))
            
            // create the attributed colour
            let attributedStringColor = [NSAttributedStringKey.foregroundColor : UIColor.white];
            // create the attributed string
            let attributedString = NSAttributedString(string: "Parar", attributes: attributedStringColor)
            self.startButton.setAttributedTitle(attributedString)
            
        } else {
            WatchTimer.stopTime = Date().timeIntervalSince1970
            startButton.setBackgroundColor(#colorLiteral(red: 0.01176470588, green: 0.2039215686, blue: 0.1176470588, alpha: 1))
            // Custom color
            let greenColor = #colorLiteral(red: 0, green: 0.9820762277, blue: 0.6320260167, alpha: 1)
            // create the attributed colour
            let attributedStringColor = [NSAttributedStringKey.foregroundColor : greenColor];
            // create the attributed string
            let attributedString = NSAttributedString(string: "Começar", attributes: attributedStringColor)
            startButton.setAttributedTitle(attributedString)
            self.presentController(withName: "timerViewController", context: openedQuestion)
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        if let detailData = context as? Question {
            openedQuestion = detailData
            
            questionDescription.setText(openedQuestion.questionTitle)
            usernameLabel.setText(openedQuestion.username)
            userPhoto.setImage(#imageLiteral(resourceName: "icons8-user_filled"))
            if openedQuestion.userPhoto != "" {
                _ = userPhoto.setImageWithUrl(url: openedQuestion.userPhoto, scale: 0.5)
            }
        }
        
        if UserDefaults.standard.string(forKey: "userID") == openedQuestion.userID || UserDefaults.standard.string(forKey: "userType") == "Teacher" {
            actionGroup.setHidden(false)
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }

}
