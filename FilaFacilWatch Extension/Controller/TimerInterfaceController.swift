//
//  TimerInterfaceController.swift
//  FilaFacilWatch Extension
//
//  Created by Luan Sobreira Eustáquio de Oliveira on 02/07/2018.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import WatchKit
import Foundation

class TimerInterfaceController: InterfaceController {

    @IBOutlet var timerLabel: WKInterfaceLabel!
    @IBOutlet var question: WKInterfaceLabel!
    @IBOutlet var user: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let time = WatchTimer.deltaTime() {
            let time = Int(time)
            let seconds: Int = Int(time % 60)
            let hours: Int = Int(time / 3600)
            let minutes: Int = Int(time % 3600 / 60)
            var minutes0 = ""
            if minutes < 10 {
                minutes0 = "0"
            }
            var seconds0 = ""
            if seconds < 10 {
                seconds0 = "0"
            }
            timerLabel.setText("\(hours):\(minutes0)\(minutes):\(seconds0)\(seconds)")
            print(time)
            WatchTimer.clearTimer()
        }
        
        if let openedQuestion = context as? Question {
            self.question.setText(openedQuestion.questionTitle)
            self.user.setText(openedQuestion.username)
        }
    }
    
    override func pop() {
        self.popToRootController()
    }
}
