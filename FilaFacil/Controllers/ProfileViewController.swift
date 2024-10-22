//
//  ProfileViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var editPhotoBtn: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var profileTypeLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    // MARK: - Properties
    let userProfileManager = UserProfileService()
    let authManager = AuthDatabaseManager()
    var currentProfile: UserProfile!
    
    var isPhotoEdited: Bool = true
    
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.clipsToBounds = true
        logoutButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveCurrentUserProfile()
        loadUserProfileInfo()
    }
    
    // MARK: - Actions
    @IBAction func saveBtn_Action(_ sender: Any) {
        saveChanges()
    }
    
    @IBAction func editCancel_Action(_ sender: Any) {
//        if isEditing {
//            editPhotoBtn.isEnabled = true
//            editPhotoBtn.isHidden = false
//            saveBtn.isEnabled = true
//            saveBtn.tintColor = UIColor().UIGreen()
//
//        } else {
//            editPhotoBtn.isEnabled = false
//            editPhotoBtn.isHidden = true
//            saveBtn.isEnabled = false
//            editPhotoBtn.isHidden = false
//        }
    }
    
    @IBAction func editPhoto_Action(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
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
                self.setupProfile()
            }
        }
    }
    
    func loadUserProfileInfo() {
        if currentProfile != nil {
            usernameLabel.text = currentProfile.username
            emailLabel.text = currentProfile.email
            profileTypeLabel.text = currentProfile.profileType
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"]
            as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"]
            as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profilePhoto.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveChanges() {
        
        let imageName = NSUUID().uuidString
        
        let storedImage = storageRef.child("profile_images").child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(self.profilePhoto.image!) {
            storedImage.putData(uploadData, metadata: nil, completion: { (_, error) in
                if error != nil {
                    print(error!)
                    return
                }
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let urlText = url?.absoluteString {
                        self.databaseRef.child("Users").child(self.currentProfile.userID)
                            .updateChildValues(["photo": urlText], withCompletionBlock: { (error, _) in
                            if error != nil {
                                print(error!)
                                return
                            }
                        })                    }
                })
            })
        }
    }
    
    func setupProfile() {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor().UIBlack().cgColor, UIColor.blue.cgColor, UIColor().UIBlack().cgColor]
        
        profilePhoto.layer.cornerRadius = profilePhoto.frame.width/2
        profilePhoto.clipsToBounds = true
        editPhotoBtn.layer.cornerRadius = editPhotoBtn.frame.width/2
        editPhotoBtn.clipsToBounds = true
        
        if isPhotoEdited {
            databaseRef.child("Users").child(currentProfile.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    self.usernameLabel.text = dict["username"] as? String
                    if let profileImageURL = dict["photo"] as? String {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                self.profilePhoto?.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
        }
        isPhotoEdited = false
    }
    
    // MARK: - Navigation
    // Opens app screens to loggedIn users
    func presentLogoutScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate!
//        appDelegate.window?.rootViewController = viewController
        
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController = viewController
    }
}
