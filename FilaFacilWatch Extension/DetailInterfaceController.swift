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
    @IBOutlet var cancelButton: WKInterfaceButton!
    @IBOutlet var startButton: WKInterfaceButton!
    
    var openedQuestion: Question!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        
        if let detailData = context as? Question {
            openedQuestion = detailData
            
            questionDescription.setText(openedQuestion.questionTitle)
            usernameLabel.setText(openedQuestion.username)
        
            
            if openedQuestion.userPhoto != "" {
                _ = userPhoto.setImageWithUrl(url: openedQuestion.userPhoto, scale: 0.5)
            }
        }
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    @IBAction func startTimer() {
        
    }
}
