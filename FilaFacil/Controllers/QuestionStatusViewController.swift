//
//  QuestionStatusViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class QuestionStatusViewController: UIViewController {

    // MARK: - Properties
    let authManager = AuthService()
    let userProfileManager = UserProfileService()
    let questionDatabaseManager = QuestionProfileService()
    var currentProfile: UserProfile?

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        retrieveCurrentUserProfile()
    }
    
    override func viewDidLoad() {
        loadQuestionView()
    }
    
    // MARK: - Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            if let userProfile = userProfile {
                self.currentProfile = userProfile
            }
            // Add to mainThread reload view with data
            DispatchQueue.main.async {
                self.viewDidLoad()
            }
        }
    }
    
    func loadQuestionView() {
        if currentProfile?.profileType == "Teacher" {
            presentLineStatusView()
        } else if currentProfile?.profileType == "Aluno" {
//            if(currentProfile?.userInLine)! {
//                presentProfileQuestionStatusView()
//            } else {
                presentNewQuestionView()
//            }
        }
    }
    
    func presentNewQuestionView() {
        let childViewController = UIStoryboard(name: "NewQuestionView",
                                               bundle: nil).instantiateViewController(withIdentifier: "NewQuestionViewController")
        self.addChildViewController(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
    
    func presentProfileQuestionStatusView() {
        let childViewController = UIStoryboard(name: "ProfileQuestionStatusView",
                                               bundle: nil).instantiateViewController(withIdentifier: "ProfileQuestionStatusViewController")
        self.addChildViewController(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
    
    func presentLineStatusView() {
        let childViewController = UIStoryboard(name: "LineStatusView",
                                               bundle: nil).instantiateViewController(withIdentifier: "LineStatusViewController")
        self.addChildViewController(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
}
