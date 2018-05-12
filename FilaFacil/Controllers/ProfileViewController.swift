//
//  ProfileViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileTypeLabel: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: - Properties
    let userProfileManager = UserProfileService()
    let authManager = AuthDatabaseManager()
    var currentProfile: UserProfile!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        retrieveCurrentUserProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveCurrentUserProfile()
        loadUserProfileInfo()
    }
    
    // MARK: - Actions
    @IBAction func click_BackBtn(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func click_Logout(_ sender: Any) {
        authManager.signOut()
        presentLogoutScreen()
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
        }
    }
    
    func loadUserProfileInfo() {
        usernameLabel.text = currentProfile.username
        emailLabel.text = currentProfile.email
        profileTypeLabel.text = currentProfile.profileType
    }
    
    // MARK: - Navigation
    // Opens app screens to loggedIn users
    func presentLogoutScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate!
        appDelegate?.window?.rootViewController = viewController
    }
}
