//
//  ProfileViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
//import Firebase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var editPhotoBtn: UIButton!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!

    @IBOutlet weak var photoView: UIView!
    
    @IBAction func openSettings(_ sender: UIButton) {
        let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(settingsUrl, completionHandler: nil)
        } else {
            UIApplication.shared.openURL(settingsUrl)
        }
    }
    
    // MARK: - Properties
    let userProfileManager = UserProfileService()
    let authManager = AuthDatabaseManager()
    var currentProfile: UserProfile!
    
    var isPhotoEdited: Bool = true
    
    //let storageRef = Storage.storage().reference()
    //let databaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.layer.cornerRadius = photoView.frame.width / 2.0
        photoView.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retrieveCurrentUserProfile()
    }
    
    @IBAction func editPhoto_Action(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    @IBAction func click_Logout(_ sender: Any) {
        //authManager.signOut()
        presentLogoutScreen()
    }
    
    // MARK: - Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let emailVC = segue.destination as? EditEmailViewController {
            emailVC.delegate = self
        } else if let passwordVC = segue.destination as? EditPasswordViewController {
            passwordVC.delegate = self
        }
    }
    
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile {[weak self] (userProfile) in
            if let userProfile = userProfile {
                self?.currentProfile = userProfile
                DispatchQueue.main.async {
                    self?.setupProfile()
                }
            }
            self?.loadUserProfileInfo()
        }
    }
    
    func loadUserProfileInfo() {
        if currentProfile != nil {
            emailLabel.text = currentProfile.email
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
            saveChanges()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveChanges() {
        
    }
    
    func setupProfile() {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor().UIBlack().cgColor, UIColor.blue.cgColor, UIColor().UIBlack().cgColor]
        
//        profilePhoto.layer.cornerRadius = profilePhoto.frame.width/2
//        profilePhoto.clipsToBounds = true
//        editPhotoBtn.layer.cornerRadius = editPhotoBtn.frame.width/2
//        editPhotoBtn.clipsToBounds = true
        
        
        
        
        if isPhotoEdited {
//            databaseRef.child("Users").child(currentProfile.userID).observeSingleEvent(of: .value, with: { (snapshot) in
//                if let dict = snapshot.value as? [String: AnyObject] {
//                    if let profileImageURL = dict["photo"] as? String {
//                        let url = URL(string: profileImageURL)
//                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
//                            if error != nil {
//                                print(error!)
//                                return
//                            }
//                            DispatchQueue.main.async {
//                                self.profilePhoto?.image = UIImage(data: data!)
//                            }
//                        }).resume()
//                    }
//                }
//            })
        }
        isPhotoEdited = false
    }
    
    // MARK: - Navigation
    // Opens app screens to loggedIn users
    func presentLogoutScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "LoginView", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        let appDelegate = UIApplication.shared.delegate as? AppDelegate?
        appDelegate??.window?.rootViewController = viewController
    }
}

extension ProfileViewController: EditEmailViewControllerDelegate {
    func change(email: String, _ password: String) {
//        AuthService().login(email: Auth.auth().currentUser!.email!, password: password, completionHandler: {user in
//            if user != nil {
//            self.databaseRef.child("Users").child(
//                self.currentProfile.userID).updateChildValues(
//                    ["email": email],
//                    withCompletionBlock: {(error, _) in
//                    if error != nil {
//                        print(error!)
//                        return
//                    } else {
//                        Auth.auth().currentUser?.updateEmail(to: email, completion: {[weak self](error) in
//                            if error == nil {
//                                DispatchQueue.main.async {
//                                    self?.emailLabel.text = email
//                                }
//                            } else {
//                                print(error!)
//                            }
//                        })
//                    }
//                })
//            }
//        })
    }
}

extension ProfileViewController: EditPasswordViewControllerDelegate {
    func change(password: String, to newPassword: String) {
//        AuthService().login(email: Auth.auth().currentUser!.email!, password: password, completionHandler: {user in
//            if user != nil {
//                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: {error in
//                    if error != nil {
//                        print(error!)
//                    }
//                })
//            }
//        })
    }
}
