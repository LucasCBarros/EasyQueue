//
//  CreateNoteViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 21/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class CreateNoteViewController: MyViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var noteTextView: UITextView!
    
    // MARK: - Properties
    let noteProfileManager = NoteProfileService()
    let userProfileManager = UserProfileService()
    
    var editNote: NoteProfile!
    var currentProfile: UserProfile?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noteTextView.delegate = self
        self.retrieveCurrentUserProfile()
        
        if editNote != nil {
            noteTextView.text = editNote.noteText
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Update currentUser
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            self.currentProfile = userProfile!
        }
    }
    
    // MARK: - Actions
    @IBAction func createNote_Action(_ sender: Any) {
        
        if editNote == nil {
            // Get typed text if not empty
            if let noteText = noteTextView.text, !noteText.isEmpty {
                if noteText.count < 131 {
                    // Inserts question info in Firebase and updates users status
                    noteProfileManager.createNote(userID: currentProfile!.userID, noteText: noteText)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Até 130 caracteres!", message: "Ultrapassou o limite de caracteres", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Assunto vazio!", message: "Preencha o campo de assunto", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            // Update Note with new text
            if let noteText = noteTextView.text, !noteText.isEmpty {
                if noteText.count < 131 {
                    noteProfileManager.updateNote(noteID: editNote.noteID, newText: noteText)
                    self.navigationController?.popViewController(animated: true)
                } else {
                    let alert = UIAlertController(title: "Até 130 caracteres!", message: "Ultrapassou o limite de caracteres", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Methods
    // Retrieve logged user
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            if let userProfile = userProfile {
                self.currentProfile = userProfile
            }
        }
    }
}

extension CreateNoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let text = textView.text, text == "Até 130 caracteres" {
            textView.text = ""
            textView.textColor = .black
            textView.font = UIFont(name: "SFProText-Regular", size: 17)
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let text = textView.text, text.isEmpty {
            textView.text = "Até 130 caracteres"
            textView.textColor = .lightGray
            textView.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        }
        textView.resignFirstResponder()
    }
    
}
