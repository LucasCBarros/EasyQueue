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
    @IBOutlet weak var loadingPhoto: UIActivityIndicatorView!
    
    @IBOutlet weak var photoView: UIView!
    
    // MARK: - Properties
    let userProfileManager = UserProfileService()
    let authManager = AuthDatabaseManager()
    var currentProfile: UserProfile!
    
    var isPhotoEdited: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoView.layer.cornerRadius = photoView.frame.width / 2.0
        photoView.clipsToBounds = true
        
        retrieveCurrentUserProfile()

    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func editPhoto_Action(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
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
            
            DispatchQueue.main.async {
                self.emailLabel.text = self.currentProfile.email
                self.loadingPhoto.startAnimating()

            }
            
            userProfileManager.retrieveImage(for: self.currentProfile.userID) { (data, error) in
                
                if let data = data {
                    DispatchQueue.main.async {
                        self.profilePhoto.image = UIImage(data: data)
                        self.loadingPhoto.stopAnimating()
                    }
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        var selectedImageFromPicker: Any?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            if let photo = selectedImage as? UIImage {
                profilePhoto.image = photo
                
                loadingPhoto.startAnimating()
                userProfileManager.saveImage(UIImagePNGRepresentation(photo)!, for: currentProfile) { (error) in
                    if error == nil {
                        print("Imagem salva com sucesso")
                        DispatchQueue.main.async {
                            self.loadingPhoto.stopAnimating()
                        }
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupProfile() {
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor().UIBlack().cgColor, UIColor.blue.cgColor, UIColor().UIBlack().cgColor]
        
        if isPhotoEdited {

        }
        isPhotoEdited = false
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
