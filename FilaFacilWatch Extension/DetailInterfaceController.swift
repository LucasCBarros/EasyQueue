//
//  DetailInterfaceController.swift
//  FilaFacilWatch Extension
//
//  Created by Lucas Barros on 19/06/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import Foundation
import WatchKit

class DetailInterfaceController:  InterfaceController {
    
    @IBOutlet var topPanelBG: WKInterfaceGroup!
    @IBOutlet var questionDescriptionBG: WKInterfaceGroup!
    @IBOutlet var questionDescription: WKInterfaceLabel!
    @IBOutlet var usernameLabel: WKInterfaceLabel!
    @IBOutlet var userPhoto: WKInterfaceImage!
    @IBOutlet var timeStampLabel: WKInterfaceLabel!
    @IBOutlet var questionTypeColor: WKInterfaceGroup!
    
    var openedQuestion: Question!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        topPanelBG.setBackgroundColor(UIColor.darkGray)
        questionDescriptionBG.setBackgroundColor(UIColor.darkGray)
        
        if let detailData = context as? Question {
            openedQuestion = detailData
            
            questionDescription.setText(openedQuestion.questionTitle)
            usernameLabel.setText(openedQuestion.username)
            
            questionTypeColor.setBackgroundColor(openedQuestion.categoryQuestion.color)
//            questionTypeColor.setBackgroundColor(UIColor.red)
//            rowController.questionTypeColor.setBackgroundColor(openedQuestions[index].categoryQuestion.color)
            
            //Tirar o timestamp e colocar a data e hora
            let timeInterval = Double.init(self.openedQuestion.questionID)
            let date = Date(timeIntervalSince1970: timeInterval! / 1000)
            let strDate = Formatter.dateToString(date)
            timeStampLabel.setText(strDate)
            
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
}
