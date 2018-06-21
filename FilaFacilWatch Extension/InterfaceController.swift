//
//  InterfaceController.swift
//  FilaFacilWatch Extension
//
//  Created by Lucas Barros on 19/06/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import WatchKit
import Foundation
import Kingfisher


class InterfaceController: WKInterfaceController {

    @IBOutlet var lineTableView: WKInterfaceTable!
    
    var questionService = QuestionService()
    var openedQuestions: [Question] = []
    
    var noteService = NoteService()
    var openedNotes: [Note] = []
    var topTimer: Timer!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        getAllQuestions()
//        getAllNotes()
        
        topTimer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self,
                                        selector: #selector(InterfaceController.getAllInformations),
                                        userInfo: nil, repeats: true)
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
                for index in 0..<openedQuestions.count {
                    if let rowController = lineTableView.rowController(at: index) as? RowController {
                        rowController.questionLabel.setText(openedQuestions[index].questionTitle)
                        rowController.usernameLabel.setText(openedQuestions[index].username)
                        rowController.questionTypeColor.setBackgroundColor(openedQuestions[index].categoryQuestion.color)
                        
                        if openedQuestions[index].userPhoto != "" {
                            rowController.userPhoto.setImageWithUrl(url: openedQuestions[index].userPhoto, scale: 0.5)
                        }
                    }
                }
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        pushController(withName: "DetailInterfaceController", context: openedQuestions[rowIndex])
    }
    
    @objc func getAllInformations() {
        getAllQuestions()
//        getAllNotes()
    }
    
    func getAllQuestions() {
        questionService.getAllQuestions(completion: {[weak self] (questions, error) in
            if error == nil {
                let questions = questions.sorted(by: { (question1, question2) -> Bool in
                    return question1.questionID < question2.questionID
                })
                if questions.count == 0 || self?.openedQuestions != questions {
                    self?.openedQuestions.removeAll()
                    self?.openedQuestions = questions
                    DispatchQueue.main.async {
//                        self?.questionTableView.reloadData()
                        self?.loadTableData()
                    }
                }
            }
        })
    }
    
//    func getAllNotes() {
//        noteService.getAllQuestions(completion: {[weak self] (notes, error) in
//            if error == nil {
//                let notes = notes.sorted(by: { (note1, note2) -> Bool in
//                    return note1.noteID < note2.noteID
//                })
//                if notes.count == 0 || self?.openedNotes != notes {
//                    self?.openedNotes.removeAll()
//                    self?.openedNotes = notes
//                    DispatchQueue.main.async {
////                        self?.noteCollectionView.reloadData()
//                    }
//                }
//            }
//        })
//    }

}
