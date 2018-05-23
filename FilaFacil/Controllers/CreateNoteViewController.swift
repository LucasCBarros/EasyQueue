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
    @IBOutlet weak var createNoteButton: UIButton!
    
    var allNoteProfiles: [NoteProfile]?
    
    let noteProfileManager = NoteProfileService()
    let userProfileManager = UserProfileService()
    
    var currentProfile: UserProfile {
        get {
            var profile = UserProfile(dictionary: [:])

            if let tabbarcontroller = self.tabBarController,
                let firstTabController = tabbarcontroller.viewControllers?.first,
                let lineListController = firstTabController as? LineListViewController {
                if let currentProfile = lineListController.currentProfile {
                    profile = currentProfile
                }
            }
            return profile
        }
        set(newValue) {
            (self.tabBarController!.viewControllers![0] as? LineListViewController)?.currentProfile = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newNoteView.frame.size.width = self.view.frame.width
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveAllNotes()
        
        // Update currentUser
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            self.currentProfile = userProfile!
        }
    }
    
    @IBAction func createNote_Action(_ sender: Any) {
        self.createNote()
        noteTableView.reloadData()
        animateOut()
    }
    
    @IBAction func newNote_Action(_ sender: Any) {
        animateIn()
    }
    
    func orderListElements() {
        allNoteProfiles = allNoteProfiles?.sorted { $0.noteID < $1.noteID }
    }

    func retrieveAllNotes() {
        noteProfileManager.retrieveAllOpenNotes { (noteProfile) in
            if let noteProfile = noteProfile {
                self.allNoteProfiles = noteProfile
            }

            // Add to main Thread
            DispatchQueue.main.async {
                self.orderListElements()
                self.noteTableView.reloadData()
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
        noteProfileManager.createNote(userID: currentProfile.userID, noteText: noteText)
        self.retrieveAllNotes()
    }
    
    func animateIn() {
        self.view.addSubview(newNoteView)
        newNoteView.center = self.view.center
        
        newNoteView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        newNoteView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.newNoteView.alpha = 1
            self.newNoteView.transform = CGAffineTransform.identity
        }
    }
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.newNoteView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.newNoteView.alpha = 0
        }) {(_: Bool) in
            self.newNoteView.removeFromSuperview()
        }
    }
}
extension CreateNoteViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if allNoteProfiles == nil {
            return 3
        } else {
            return allNoteProfiles!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as? NoteCell
        
        cell?.selectionStyle = .none // Removes selection
        
        if allNoteProfiles != nil {
            let timeInterval = Double(Int((self.allNoteProfiles?[indexPath.row].noteID)!)!)
            let date = Date(timeIntervalSince1970: timeInterval / 1000)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            
            cell?.noteDate.text = strDate
            cell?.noteText.text = self.allNoteProfiles?[indexPath.row].noteText
        } else {
            cell?.noteText.text = "Hello"
            cell?.noteDate.text = "\(Date())"
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
        if self.allNoteProfiles?[indexPath.row].userID == currentProfile.userID || self.currentProfile.profileType == "Teacher" {
            return true
        } else {
            return false
        }
    }

}
