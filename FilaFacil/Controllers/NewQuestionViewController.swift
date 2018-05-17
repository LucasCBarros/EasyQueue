//
//  NewQuestionViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NewQuestionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var openQuestionBtn: UIButton!
    @IBOutlet weak var teacherPicker: UIPickerView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    let questionProfileManager = QuestionProfileService()
    let userProfileManager = UserProfileService()
    var allUserProfiles: [UserProfile]?
    var usersInLine: [UserProfile]?
    var selectedTeacher = "All"
    var teacherArray = [ "Dev", "Design", "Biz"]
    
    var currentProfile: UserProfile {
        get {
            var profile = UserProfile(dictionary: [:])
            
            if let tabbarcontroller = self.tabBarController,
                let firstTabController = tabbarcontroller.viewControllers?.first,
                let lineListController = firstTabController as? LineListViewController {
                if let currentProfile = lineListController.currentProfile {
                    profile = currentProfile
                }
            }
            return profile
        }
        set(newValue) {
            (self.tabBarController!.viewControllers![0] as? LineListViewController)?.currentProfile = newValue
        }
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        questionField.textColor = UIColor.white
        questionField.attributedPlaceholder = NSAttributedString(string: "What's your question?",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveAllUsers()
    }
    
    // MARK: - Actions
    // Create new question
    @IBAction func click_OpenQuestionBtn(_ sender: Any) {
        print(self.usersInLine?.count as Any)
        // create new question function
        createQuestion()
        // Present next view
        presentProfileQuestionStatusView()
    }
    
    // MARK: - Methods
    // Create new question in Firebase
    func createQuestion() {
        var questionText = " "
        // Get typed text if not empty
        if !(questionField.text?.isEmpty)! {
            questionText = questionField.text!
        }
        
        // Inserts question info in Firebase and updates users status
        questionProfileManager.createQuestion(userID: currentProfile.userID, questionTxt: questionText,
                                              username: currentProfile.username,
                                              requestedTeacher: selectedTeacher,
                                              positionInLine: (usersInLine?.count)!+1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Calls next view
    func presentProfileQuestionStatusView() {
        
        let childViewController = UIStoryboard(name: "ProfileQuestionStatusView",
                                               bundle: nil).instantiateViewController(withIdentifier: "ProfileQuestionStatusViewController")
        self.addChildViewController(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
    
    // Retrieve all users registered in Firebase
    func retrieveAllUsers() {
        userProfileManager.retrieveAllUsersInLine { (userProfile) in
            if let userProfile = userProfile {
                self.allUserProfiles = userProfile
            }
            
            // Filters returned users array
            self.retrieveAllUsersInLine()
        }
    }
    
    // Filters AllUsers array for users in line
    func retrieveAllUsersInLine() {
        if self.allUserProfiles != nil {
            self.usersInLine = self.userProfileManager.filterUsersInLine(allUsers: self.allUserProfiles!)
        }
    }
}

// MARK: - PickerView functions
extension NewQuestionViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // Number of texts in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of texts in picker
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teacherArray.count
    }
    
    // Saves selected text in picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTeacher = teacherArray[row]
    }
    
    // Sets text and textColor for Picker
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = teacherArray[row]
        let myTitle = NSAttributedString(string: titleData,
                                         attributes: [NSAttributedStringKey.font: UIFont(name: "Georgia", size: 15.0)!,
                                                      NSAttributedStringKey.foregroundColor: UIColor.white ])
        return myTitle
    }
}
