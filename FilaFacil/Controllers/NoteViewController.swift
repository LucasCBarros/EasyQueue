//
//  CreateNoteViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NoteViewController: MyViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var allNoteProfiles: [NoteProfile]?
    
    let noteProfileManager = NoteProfileService()
    let userProfileManager = UserProfileService()
    
    var currentProfile: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.retrieveCurrentUserProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveAllNotes()
        
        // Update currentUser
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            self.currentProfile = userProfile!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
    
}
extension NoteViewController {
    
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
