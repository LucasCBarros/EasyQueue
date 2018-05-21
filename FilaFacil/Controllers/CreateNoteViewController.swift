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
    @IBOutlet weak var noteText: UITextField!
    @IBOutlet weak var noteTableView: UITableView!
    @IBOutlet weak var createNoteButton: UIButton!
    
    var notes: [String] = ["Hello", "Lulalala", "Yeah!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newNoteView.frame.size.width = self.view.frame.width
    }
    
    @IBAction func createNote_Action(_ sender: Any) {
        notes.append(noteText.text!)
        noteTableView.reloadData()
        animateOut()
    }
    
    @IBAction func newNote_Action(_ sender: Any) {
        animateIn()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") as? NoteCell
        
        cell?.backgroundColor = UIColor.lightGray
        cell?.noteDate.text = "\(Date())"
        cell?.noteText.text = notes[indexPath.row]
        
        return cell!
    }
    
    // Delete cell and update student status in Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // TODO: Verify ID from who created
        if editingStyle == UITableViewCellEditingStyle.delete {
            notes.remove(at: indexPath.row)
            noteTableView.reloadData()
        }
    }
    
    // Allows to edit cell according to profile type
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}
