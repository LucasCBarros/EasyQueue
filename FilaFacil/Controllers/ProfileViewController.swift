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
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loadingPhoto: UIActivityIndicatorView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    // MARK: - Properties
    let userProfileManager = UserProfileService.shared
    let authManager = AuthDatabaseManager()
    var currentUser: UserProfile!
    
    var isPhotoEdited: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoView.layer.cornerRadius = self.photoView.frame.width / 2.0
        self.photoView.clipsToBounds = true
        self.retrieveCurrentUserProfile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    @IBAction func editPhoto_Action(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let emailVC = segue.destination as? EditUsernameViewController {
            emailVC.delegate = self
        }
    }
    
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile {[weak self] (userProfile) in
            if let userProfile = userProfile {
                self?.currentUser = userProfile
                DispatchQueue.main.async {
                    self?.setupProfile()
                }
            }
            self?.loadUserProfileInfo()
        }
    }
    
    func loadUserProfileInfo() {
        
        if currentUser != nil {
            
            DispatchQueue.main.async {
                self.usernameLabel.text = self.currentUser.username
                self.realNameLabel.text = self.currentUser.realName
                self.emailLabel.text = self.currentUser.email
                self.loadingPhoto.startAnimating()

            }
            
            userProfileManager.retrieveImage(for: self.currentUser.userID, modifiedAt: self.currentUser.photoModifiedAt) { (image, _, error) in
                
                if let image = image, error == nil {
                    DispatchQueue.main.async {
                        self.profilePhoto.image = image
                    }
                }
                DispatchQueue.main.async {
                    self.loadingPhoto.stopAnimating()
                }
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

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
                userProfileManager.saveImage(photo.pngData()!, for: currentUser) { (newUser, error)  in
                    if error == nil {
                        print("Imagem salva com sucesso")
                        if let user = newUser {
                            self.currentUser = user
                        }
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

extension ProfileViewController: EditUsernameViewControllerDelegate {
    func change(username: String) {
        
        currentUser.username = username
        
        userProfileManager.editUsername(user: currentUser) { (user, error) in
            DispatchQueue.main.async {
                if error != nil {
                    let alert = UIAlertController(title: "Erro ao atualizar username", message: nil, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    UserProfileService.shared.retrieveCurrentUserProfile(completion: { (user) in
                        self.currentUser = user
                        self.usernameLabel.text = self.currentUser.username
                    })
                }
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
