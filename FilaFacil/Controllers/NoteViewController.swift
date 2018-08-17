//
//  CreateNoteViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class NoteViewController: MyViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    var allNoteProfiles: [NoteProfile]?
    
    let noteProfileManager = NoteProfileService()
    let userProfileManager = UserProfileService()
    
    var currentProfile: UserProfile?
    var editedNote: NoteProfile!
    
    // MARK: - Life Cycle
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
    
    // MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        if segue.identifier ==  "createNoteSegue" {
            if let view = segue.destination as? CreateNoteViewController {
                if editedNote != nil {
                    view.editNote = editedNote
                }
            }
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
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction.init(style: .normal, title: "Editar", handler: {[weak self] (_, indexPath) in
            print("Selected row \(indexPath.row)")
            self?.editedNote = self?.allNoteProfiles?[indexPath.row]
            self?.performSegue(withIdentifier: "createNoteSegue", sender: nil)
        })
        
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "Deletar", handler: {[weak self] (_, indexPath) in
            if let this = self {
                let alert = UIAlertController(title: "Excluir Aviso",
                                              message: "Tem certeza que deseja excluir esse aviso?",
                                            preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Excluir", style: .destructive, handler: { _ in
                    this.noteProfileManager.removeNote(noteID: (self?.allNoteProfiles?[indexPath.row].noteID)!)
                    
                    // Reload View
                    DispatchQueue.main.async {
                        this.viewWillAppear(true)
                    }
                }))
                this.present(alert, animated: true, completion: nil)
            }
        })
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        editAction.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        
        var actions: [UITableViewRowAction] = []
        
        actions.append(deleteAction)
        actions.append(editAction)
        
        return actions
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
