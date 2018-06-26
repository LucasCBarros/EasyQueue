//
//  CreateNoteViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var newNoteView: UIView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var hidenButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var allNoteProfiles: [NoteProfile]?
    
    let noteProfileManager = NoteProfileService()
    let userProfileManager = UserProfileService()
    
    @IBAction func createNote_Action(_ sender: Any) {
        self.createNote()
        noteTableView.reloadData()
        animateOut()
    }
    
    @IBAction func newNote_Action(_ sender: Any) {
        animateIn()
    }
    
    @IBAction func cancelNewNote(_ sender: UIBarButtonItem) {
        animateOut()
    }
    
    var currentProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newNoteView.frame = self.noteTableView.frame
        self.hidenButton = self.navigationBar.rightBarButtonItems?.popLast()
        self.cancelButton = self.navigationBar.leftBarButtonItems?.popLast()
        self.retrieveCurrentUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveAllNotes()
        
        // Update currentUser
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            self.currentProfile = userProfile!
        }
    }
    
    // Retrieve logged user
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            if let userProfile = userProfile {
                self.currentProfile = userProfile
            }
        }
    }
    
    func orderListElements() {
        allNoteProfiles = allNoteProfiles?.sorted { $0.noteID < $1.noteID }
    }

    func retrieveAllNotes() {
        noteProfileManager.retrieveAllOpenNotes {[weak self] (noteProfile) in
            if let noteProfile = noteProfile {
                self?.allNoteProfiles = noteProfile
            }

            // Add to main Thread
            DispatchQueue.main.async {
                self?.orderListElements()
                self?.activityIndicator.stopAnimating()
                self?.noteTableView.reloadData()
                if self?.allNoteProfiles?.count == 0 {
                    self?.noteTableView.separatorStyle = .none
                } else {
                    self?.noteTableView.separatorStyle = .singleLine
                }
            }
        }
    }
    
    func createNote() {
        var noteText = " "
        // Get typed text if not empty
        if !(noteTextField.text?.isEmpty)! {
            noteText = noteTextField.text!
        }

        // Inserts question info in Firebase and updates users status
        noteProfileManager.createNote(userID: currentProfile!.userID, noteText: noteText)
        self.retrieveAllNotes()
    }
    
    func animateIn() {
        self.view.addSubview(self.newNoteView)
        self.newNoteView.alpha = 0
        
        let addButon = self.navigationBar.rightBarButtonItems?.popLast()
        self.navigationBar.rightBarButtonItems?.append(self.hidenButton)
        self.hidenButton = addButon
        self.navigationBar.leftBarButtonItems?.append(self.cancelButton)
        UIView.animate(withDuration: 0.4) {
            self.newNoteView.alpha = 1
            self.newNoteView.transform = CGAffineTransform.identity
            self.noteTextField.becomeFirstResponder()
        }
    }
    
    @objc func animateOut() {
        let saveButton = self.navigationBar.rightBarButtonItems?.popLast()
        self.navigationBar.rightBarButtonItems?.append(hidenButton)
        self.hidenButton = saveButton
        self.navigationBar.leftBarButtonItems?.removeFirst()
        UIView.animate(withDuration: 0.3, animations: {
            self.newNoteView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.newNoteView.alpha = 0
        }) {(_: Bool) in
            self.noteTextField.text = ""
            self.newNoteView.removeFromSuperview()
        }
    }
}
extension CreateNoteViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allNoteProfiles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as? NoteCell
        
        cell?.selectionStyle = .none // Removes selection
        
        if self.allNoteProfiles != nil {
            let timeInterval = Double(Int((self.allNoteProfiles?[indexPath.row].noteID)!)!)
            let date = Date(timeIntervalSince1970: timeInterval / 1000)
            let strDate = Formatter.dateToString(date)
            
            cell?.noteDate.text = strDate
            cell?.noteText.text = self.allNoteProfiles?[indexPath.row].noteText
        }
        
        return cell!
    }
    
    // Delete cell and update student status in Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // TODO: Verify ID from who created
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            noteProfileManager.removeNote(noteID: (allNoteProfiles?[indexPath.row].noteID)!)
//            noteTableView.reloadData()
            self.viewWillAppear(true)
        }
    }
    
    // Allows to edit cell according to profile type
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.allNoteProfiles?[indexPath.row].userID == currentProfile?.userID || self.currentProfile?.profileType == "Teacher" {
            return true
        } else {
            return false
        }
    }

}
