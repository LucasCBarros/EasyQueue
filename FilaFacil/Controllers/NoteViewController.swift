//
//  CreateNoteViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NoteViewController: MyViewController {

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
        
        //print("VOLTOU!!!!!!!")
        // Update currentUser
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            self.currentProfile = userProfile!
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNote" {
            (segue.destination as? CreateNoteViewController)?.delegate = self
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
    
    func retrieveAllNotes() {
        
            noteProfileManager.retrieveOrderedNotes {[weak self] (noteProfile) in
                if let noteProfile = noteProfile {
                    self?.allNoteProfiles = noteProfile
                }
                
                // Add to main Thread
                DispatchQueue.main.async {
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

extension NoteViewController: CreateNoteViewControllerDelegate {

    func createNoteResponse(newNote: NoteProfile) {
        
        print("dsdsdsd")
        print(newNote.noteText)
        
        self.allNoteProfiles?.append(newNote)
        
        //self.noteTableView.reloadData()
    }
}

extension NoteViewController: UITableViewDataSource, UITableViewDelegate {
    
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
            let date = allNoteProfiles?[indexPath.row].createdAt
            let strDate = Formatter.dateToString(date!)
            
            cell?.noteDate.text = strDate
            cell?.noteText.text = self.allNoteProfiles?[indexPath.row].noteText
        }
        
        return cell!
    }
    
    // Delete cell and update student status in Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            if let allNotes = allNoteProfiles {
            
                noteProfileManager.removeNote(note: allNotes[indexPath.row], completion: {(error) in
                    if error == nil {
                        DispatchQueue.main.async {
                            self.allNoteProfiles?.remove(at: indexPath.row)
                            self.noteTableView.reloadData()
                        }
                    }
                })
                self.viewWillAppear(true)
            }
        }
    }
    
    // Allows to edit cell according to profile type
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.allNoteProfiles?[indexPath.row].userID == currentProfile?.userID || self.currentProfile?.profileType ==  .admin {
            return true
        } else {
            return false
        }
    }
}
