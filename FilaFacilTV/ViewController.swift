//
//  ViewController.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var openedQuestions:[Question] = []
    var questionIDArray: [String] = []
    var topTimer: Timer!
    
    @IBOutlet weak var questionTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(QuestionService().getJsonFromUrl())
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // TODO: Test
        getAllQuestions()
//        getJsonFromUrl()
        
         topTimer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self,
                                                selector: #selector(ViewController.getAllQuestions),
                                                userInfo: nil, repeats: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    struct Question {
        let questionID: String
        let questionTitle: String
        let requestedTeacher: String
        let userID: String
        let username: String
        
        init(json: [String: Any]) {
            questionID = json["questionID"] as? String ?? "?"
            questionTitle = json["questionTitle"] as? String ?? "??"
            requestedTeacher = json["requestedTeacher"] as? String ?? "???"
            userID = json["userID"] as? String ?? "????"
            username = json["username"] as? String ?? "?????"
        }
    }
    
    @objc func getAllQuestions() {
        let URL: String = "https://filafacildev.firebaseio.com/Questions.json"
        
        //creating a NSURL
        guard let url = NSURL(string: URL) else { return }
        
        //fetching the data from the url
        URLSession.shared.dataTask(with: (url as? URL)!, completionHandler: {(data, response, error) in
            
            guard let data = data else { return }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                
//                print("JSON:", json)
                
                let jsonString = ("\(json.keys)")
//                print("jsonString:", json.keys)
                
                let jsonData = jsonString.data(using: .utf8)! // Conversion to UTF-8 cannot fail.
                
                self.openedQuestions.removeAll()
                
                for (idx, elem) in json{
                    print(elem)
                    var lala = elem as? [String: Any]
                    self.openedQuestions.append(Question(json: lala!))
                }
                
                
                self.questionTableView.reloadData()
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }).resume()
        
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
            cell?.questionLabel.text = "\(indexPath.row+1)"
            cell?.numberLabel.text = self.openedQuestions[indexPath.row].requestedTeacher
        }
        
        return cell!
    }
    
    // Delete cell and update student status in Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    }
    
}

