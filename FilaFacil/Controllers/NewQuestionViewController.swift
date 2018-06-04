//
//  NewQuestionViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol NewQuestionTableViewDelegate: NSObjectProtocol {
    func saveQuestion(text: String, selectedTeacher: String)
}

class NewQuestionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var questionField: UITextField!
    
    // MARK: - Properties
    let questionProfileManager = QuestionProfileService()
    var allUserProfiles: [UserProfile]?
    var usersInLine: [UserProfile]?
    var selectedTeacher = "Developer"
    var teacherArray = [("Developer", UIColor.developer()), ("Design", UIColor.design()), ("Business", UIColor.business())]
    
    weak var delegate: NewQuestionTableViewDelegate?
    
    // MARK: - Actions
    // Create new question
    @IBAction func save(_ sender: UIBarButtonItem) {
        // create new question function
        self.createQuestion()
        // Present next view
//        self.presentProfileQuestionStatusView()
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Methods
    // Create new question in Firebase
    func createQuestion() {
        var questionText = " "
        // Get typed text if not empty
        if !(questionField.text?.isEmpty)! {
            questionText = questionField.text!
        }
        delegate?.saveQuestion(text: questionText, selectedTeacher: selectedTeacher)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Calls next view
    func presentProfileQuestionStatusView() {
        
        let childViewController = UIStoryboard(name: "ProfileQuestionStatusView",
                                               bundle: nil).instantiateViewController(withIdentifier: "ProfileQuestionStatusViewController")
        self.addChildViewController(childViewController)
        self.view.addSubview(childViewController.view)
        childViewController.didMove(toParentViewController: self)
    }
}

extension NewQuestionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? NewQuestionTableViewCell {
            for cell in tableView.visibleCells {
                if let cell = cell as? NewQuestionTableViewCell {
                    cell.checkView.backgroundColor = UIColor.clear
                }
            }
            cell.checkView.backgroundColor = teacherArray[indexPath.row].1
        }
        selectedTeacher = teacherArray[indexPath.row].0
    }
    
}

extension NewQuestionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teacherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newQuestionCell", for: indexPath)
        
        if let cell = cell as? NewQuestionTableViewCell {
            cell.typeQuestionLabel.text = teacherArray[indexPath.row].0
            if teacherArray[indexPath.row].0 == selectedTeacher {
                cell.checkView.backgroundColor = teacherArray[indexPath.row].1
            }
        }
        
        return cell
    }
    
}
