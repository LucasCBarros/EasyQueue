//
//  ViewController.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var list = [1,2,3,4,5,6,7,8]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(QuestionService().getJsonFromUrl())
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
            return list.count
        }
        
        // Shows tableView cells
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell
            cell?.profileName.text = "Name"
            cell?.questionLabel.text = "\(self.list[indexPath.row])"
            cell?.numberLabel.text = "\(self.list[indexPath.row])"
            
            return cell!
        }
        
        // Delete cell and update student status in Firebase
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        }
        
        // Allows to edit cell according to profile type
//        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//            return true
//        }
    
}

