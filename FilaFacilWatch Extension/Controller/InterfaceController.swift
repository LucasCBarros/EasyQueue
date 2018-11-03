//
//  InterfaceController.swift
//  FilaFacilWatch Extension
//
//  Created by Lucas Barros on 19/06/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController {

    @IBOutlet var lineTableView: WKInterfaceTable!
    @IBOutlet var noQuestions: WKInterfaceLabel!
    
    var questionService = QuestionService()
    var openedQuestions: [Question] = []
    
    var noteService = NoteService()
    var openedNotes: [Note] = []
    var topTimer: Timer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        self.loadTableData()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    override func didDeactivate() {
        super.didDeactivate()
    }
    
    private func loadTableData() {
        
        if lineTableView != nil {
            lineTableView.setNumberOfRows(openedQuestions.count, withRowType: "RowController")
            
            if openedQuestions.count > 0 {
                if WCSession.isSupported() {
                    // 2
                    let session = WCSession.default
                    do {
                        let dictionary = ["request": "getUser"]
                        try session.updateApplicationContext(dictionary)
                    } catch {
                        print("ERROR: \(error)")
                    }
                }
                self.noQuestions.setHidden(true)
                for index in 0..<openedQuestions.count {
                    if let rowController = lineTableView.rowController(at: index) as? RowController {
                        let question = openedQuestions[index]
                        rowController.questionLabel.setText(question.questionTitle)
                        rowController.usernameLabel.setText(question.username)
                        //Tirar o timestamp e colocar a data e hora
                        if let timeInterval = Double.init(question.questionID) {
                            let date = Date(timeIntervalSince1970: timeInterval / 1000)
                            let strDate = Formatter.dateToString(date)
                            rowController.dateLabel.setText(strDate)
                        }
                        rowController.questionTypeColor.setBackgroundColor(question.categoryQuestion.color)
                    }
                }
            } else {
                self.noQuestions.setHidden(false)
                self.noQuestions.setText(UserDefaults.standard.string(forKey: "userID"))
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "DetailInterfaceController", context: openedQuestions[rowIndex])
    }
}
