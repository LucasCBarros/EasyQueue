//
//  LineStatusViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class LineStatusViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var firstStudentLabel: UILabel!
    @IBOutlet weak var waitingTimeLabel: UILabel!
    @IBOutlet weak var lineSizeLabel: UILabel!
    @IBOutlet weak var alertBtn: UIButton!
    
    // MARK: - Properties
    let userProfileManager = UserProfileService()
    let questionProfileManager = QuestionProfileService()
    
    var usersInLine: [UserProfile]?
    var inLineQuestions: [QuestionProfile]?
    var date = Date()
    
    // Time variables
    var timer: Timer!
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    var fractions: Int = 0
    var clockString: String = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        alertBtn.isHidden = true
        waitingTimeLabel.text = "00:00:00"
        loadViewData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.timer != nil {
            timer.invalidate()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadViewData()
    }
    
    // MARK: - Actions
    @IBAction func click_CallNextBtn(_ sender: Any) {
        if(usersInLine?.count)! > 0 {
            userProfileManager.removeUserFromLine(userID: usersInLine![0].userID, questionID: inLineQuestions![0].questionID)
            self.reloadViewData()
        }
        
        if (usersInLine?.count)!-1 == 0 {
            timer.invalidate()
            lineSizeLabel.text = "00"
            waitingTimeLabel.text = "00:00:00"
            firstStudentLabel.text = "None"
        }
    }
    
    // MARK: - Methods
    func reloadViewData() {
        retrieveAllUsersInLine()
        retrieveAllQuestionsInLine()
    }
    
    func loadViewData() {
        self.orderListElements()
        
        if let usersInLine = usersInLine {
            if usersInLine.count > 0 {
                lineSizeLabel.text = "\(usersInLine.count)"
                firstStudentLabel.text = usersInLine[0].username
                updateWaitingClock()
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func retrieveAllUsersInLine() {
        userProfileManager.retrieveAllUsersInLine { (userProfile) in
            if let userProfile = userProfile {
                self.usersInLine = userProfile
            }
            if self.usersInLine != nil {
                self.usersInLine = self.userProfileManager.filterUsersInLine(allUsers: self.usersInLine!)
                
                self.retrieveAllQuestionsInLine()
                
                // Add to main Thread
                DispatchQueue.main.async {
                    self.loadViewData()
                }
            }
        }
    }
    
    func retrieveAllQuestionsInLine() {
        questionProfileManager.retrieveAllOpenQuestions { (questionProfile) in
            if let questionProfile = questionProfile {
                self.inLineQuestions = questionProfile
            }
            if self.inLineQuestions != nil {
                self.inLineQuestions = self.questionProfileManager.filterQuestionsInLine(allUsers: self.usersInLine!,
                                                                                         allQuestions: self.inLineQuestions! )
                // Add to main Thread
                DispatchQueue.main.async {
                    self.loadViewData()
                }
            }
        }
    }
    
    func orderListElements() {
        usersInLine = usersInLine?.sorted { $0.questionID < $1.questionID }
        inLineQuestions = inLineQuestions?.sorted { $0.questionID < $1.questionID }
    }

}

// MARK: - Clock functions
extension LineStatusViewController {
    
    func updateWaitingClock() {
        
        if self.timer == nil {
            updateClockParameters()
            self.timer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(LineStatusViewController.updateClock),
                                              userInfo: nil, repeats: true)
        }
        
    }
    
    func updateClockParameters() {
        
        let refDate = Int(self.usersInLine![0].questionID)!
        let now = Int(Date().millisecondsSince1970)
        
        let fromDate = Date(milliseconds: refDate)
        let nowDate = Date(milliseconds: now)
        
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([ .second])
        let myDate = calendar.dateComponents(unitFlags, from: fromDate, to: nowDate)
        let mySeconds = myDate.second
        
        self.seconds = (mySeconds!)%60
        self.minutes = (mySeconds!/60)%60
        self.hours = ((mySeconds!/60)/60)
    }
    
    @objc func updateClock() {
        seconds+=1
        
        if seconds >= 60 {
            seconds=0
            minutes+=1
        }
        if minutes >= 60 {
            seconds=0
            hours+=1
        }
        
        let secondsString = seconds>9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes>9 ? "\(minutes)" : "0\(minutes)"
        let hoursString = hours>9 ? "\(hours)" : "0\(hours)"
        
        clockString = "\(hoursString):\(minutesString):\(secondsString)"
        waitingTimeLabel.text = clockString
    }
}
