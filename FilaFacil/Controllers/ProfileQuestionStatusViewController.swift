//
//  ProfileQuestionStatusViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ProfileQuestionStatusViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var closeQuestionBtn: UIButton!
    @IBOutlet weak var yourPositionLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var openedQuestionLabel: UILabel!
    
    // MARK: - Properties
    let userProfileManager = UserProfileService()
    let questionProfileManager = QuestionProfileService()
    var currentQuestion: QuestionProfile?

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
    // Final Load
    override func viewDidLoad() {
        loadViewData()
    }
    
    // Retrieve View Data
    override func viewWillAppear(_ animated: Bool) {
        retrieveCurrentUserProfile()
    }
    
    // MARK: - Actions
    // Button click to remove user from line
    @IBAction func click_LeaveLineBtn(_ sender: Any) {
        leaveLine()
    }
    
    // Reload view info
    @IBAction func click_ReloadView(_ sender: Any) {
        retrieveCurrentUserProfile()
    }
    
    // MARK: - Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Remove user from line and changes his status
    func leaveLine() {
        userProfileManager.removeUserFromLine(userID: currentProfile.userID, questionID: currentProfile.questionID)
        presentNewQuestionView()
    }
    
    // Retrieve the current user profile info
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            if let userProfile = userProfile {
                self.currentProfile = userProfile
            }
            // Add to main Thread
            DispatchQueue.main.async {
                if !(self.currentProfile.questionID.isEmpty) {
                    self.retrieveCurrentQuestion()
                }
//                self.loadViewData()
            }
        }
    }
    
    // Retrieves the users question
    func retrieveCurrentQuestion() {
        questionProfileManager.retrieveCurrentQuestion(questionID: currentProfile.questionID,
                                                       completion: { (currentQuestion) in
            if let currentQuestion = currentQuestion {
                self.currentQuestion = currentQuestion
            }
            // Add to main Thread
            DispatchQueue.main.async {
                self.loadViewData()
            }
        })
    }
    
    // Loads data in View
    func loadViewData() {
        positionLabel.text = "\(currentProfile.userLinePosition)"
        
        if currentQuestion != nil {
            openedQuestionLabel.text = currentQuestion?.questionTitle
        }
    }
 
    // MARK: - Navigation
    // Presentes view after opened question
    func presentNewQuestionView() {
        let childViewController = UIStoryboard(name: "NewQuestionView", bundle: nil)
            .instantiateViewController(withIdentifier: "NewQuestionViewController")
        self.addChildViewController(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
}
