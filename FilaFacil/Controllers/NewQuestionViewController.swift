//
//  NewQuestionViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

protocol NewQuestionTableViewDelegate: NSObjectProtocol {
    func selectedLine() -> String
    func saveQuestion(text: String, selectedTeacher: String)
}

class NewQuestionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var questionField: UITextField!
    
    // MARK: - Properties
    let questionProfileManager = QuestionProfileService()
    var allUserProfiles: [UserProfile]?
    var usersInLine: [UserProfile]?
    var selectedLine = "Developer"
    var teacherArray = [("Developer", UIColor.developer()), ("Design", UIColor.design()), ("Business", UIColor.business())]
    
    weak var delegate: NewQuestionTableViewDelegate?
    
    // MARK: - Actions
    // Create new question
    @IBAction func save(_ sender: UIBarButtonItem) {
        // create new question function
        if let questionText = questionField.text, !questionText.isEmpty {
            if questionText.count > 131 {
                let alert = UIAlertController(title: "Até 130 caracteres!", message: "Ultrapassou o limite de caracteres", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                delegate?.saveQuestion(text: questionText, selectedTeacher: selectedLine)
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let alert = UIAlertController(title: "Assunto vazio!", message: "Preencha o campo de assunto", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.selectedLine = self.delegate?.selectedLine() ?? self.selectedLine
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
        selectedLine = teacherArray[indexPath.row].0
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
            if teacherArray[indexPath.row].0 == selectedLine {
                cell.checkView.backgroundColor = teacherArray[indexPath.row].1
            }
        }
        
        return cell
    }
    
}
