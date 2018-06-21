//
//  LineStatusViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class LineStatusViewController: UIViewController {

//    // MARK: - Outlets
//    @IBOutlet weak var firstStudentLabel: UILabel!
//    @IBOutlet weak var waitingTimeLabel: UILabel!
//    @IBOutlet weak var lineSizeLabel: UILabel!
//    @IBOutlet weak var alertBtn: UIButton!
//    
//    // MARK: - Properties
//    let userProfileManager = UserProfileService()
//    let questionProfileManager = QuestionProfileService()
//    
//    var inLineQuestions: [QuestionProfile]?
//    var date = Date()
//    
//    // Time variables
//    var timer: Timer!
//    var hours: Int = 0
//    var minutes: Int = 0
//    var seconds: Int = 0
//    var fractions: Int = 0
//    var clockString: String = ""
//    
//    // MARK: - Life Cycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        alertBtn.isHidden = true
//        waitingTimeLabel.text = "00:00:00"
//        loadViewData()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        if self.timer != nil {
//            timer.invalidate()
//        }
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        self.reloadViewData()
//    }
//    
//    // MARK: - Actions
//    @IBAction func click_CallNextBtn(_ sender: Any) {
////        if(usersInLine?.count)! > 0 {
////            userProfileManager.removeQuestionFromLine(questionID: inLineQuestions![0].questionID)
////            self.reloadViewData()
////        }
////
////        if (usersInLine?.count)!-1 == 0 {
////            timer.invalidate()
////            lineSizeLabel.text = "00"
////            waitingTimeLabel.text = "00:00:00"
////            firstStudentLabel.text = "None"
////        }
//    }
//    
//    // MARK: - Methods
//    func reloadViewData() {
//        retrieveAllQuestionsInLine()
//    }
//    
//    func loadViewData() {
//        self.orderListElements()
//    }
//    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//    
//    func retrieveAllQuestionsInLine() {
//        
//        questionProfileManager.retrieveAllOpenQuestions(lineName: lineName) { (questionProfile) in
//            if let questionProfile = questionProfile {
//                self.inLineQuestions = questionProfile
//            }
//            if self.inLineQuestions != nil {
//                // Add to main Thread
//                DispatchQueue.main.async {
//                    self.loadViewData()
//                }
//            }
//        }
//    }
//    
//    func orderListElements() {
//        inLineQuestions = inLineQuestions?.sorted { $0.questionID < $1.questionID }
//    }

}
