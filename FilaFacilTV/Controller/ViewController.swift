//
//  ViewController.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var questionService = QuestionService()
    var openedQuestions:[Question] = []
    var questionIDArray: [String] = []
    var topTimer: Timer!
    
    @IBOutlet weak var questionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllQuestions()
        topTimer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self,
                                                selector: #selector(ViewController.getAllQuestions),
                                                userInfo: nil, repeats: true)

    }
    
    @objc func getAllQuestions(){
        questionService.getAllQuestions(completion: {(questions, error) in
            if error == nil{
                if self.openedQuestions != questions {
                    self.openedQuestions.removeAll()
                    self.openedQuestions = questions
                    DispatchQueue.main.async {
                        self.questionTableView.reloadData()
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - TableView functions
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.openedQuestions.count
        return openedQuestions.count
    }
    
    // Shows tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell
        
        if(self.openedQuestions.count > 0) {
            cell?.profileName.text = self.openedQuestions[indexPath.row].username
            cell?.questionLabel.text = self.openedQuestions[indexPath.row].questionTitle
            cell?.numberLabel.text = "\(indexPath.row+1)"
            cell?.viewTypeQuestion.backgroundColor = self.openedQuestions[indexPath.row].categoryQuestion.color
            
            //TODO: Tirar o timestamp e colocar a data e hora
            cell?.timeInputQuestion.text = self.openedQuestions[indexPath.row].questionID
            
        }
        
        return cell!
    }
    
    // Delete cell and update student status in Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = (tableView.cellForRow(at: indexPath) as? QuestionTableViewCell) {
            cell.questionLabel.textColor = UIColor.black
            cell.profileName.textColor = UIColor.black
            cell.timeInputQuestion.textColor = UIColor(red: 59, green: 59, blue: 59, alpha: 1)
        }
    }
    
}

