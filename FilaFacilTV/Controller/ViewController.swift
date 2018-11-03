//
//  ViewController.swift
//  FilaFacilTV
//
//  Created by Jessica Batista de Barros Cherque on 17/05/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var noteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noteCollectionView: UICollectionView!
    @IBOutlet weak var questionActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noQuestions: UILabel!
    @IBOutlet weak var noNotes: UILabel!
    @IBOutlet weak var questionTableView: UITableView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var simulatedDeveloperBadge: UIView! {
        didSet {
            simulatedDeveloperBadge.layer.cornerRadius = 17.5
            simulatedDeveloperBadge.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var developerNumber: UILabel!
    @IBOutlet weak var simulatedDesignBadge: UIView! {
        didSet {
            simulatedDesignBadge.layer.cornerRadius = 17.5
            simulatedDesignBadge.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var designNumber: UILabel!
    @IBOutlet weak var simulatedBusinessBadge: UIView! {
        didSet {
            simulatedBusinessBadge.layer.cornerRadius = 17.5
            simulatedBusinessBadge.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var businessNumber: UILabel!
    
    var questionService = QuestionProfileService()
    var openedQuestions: [QuestionProfile] = []
    var noteService = NoteProfileService()
    var openedNotes: [NoteProfile] = []
    var topTimer: Timer!
    var teacherArray: [String:PresentableLine] = [:]
    var selectedTab: PresentableLine?
    
    
    var screenSaverTimeInterval: TimeInterval? = nil
    weak var screenSaverViewController: ScreenSaverViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = noteCollectionView.collectionViewLayout as? NoteCollectionViewLayout {
            layout.delegate = self
        }
        
        LineService.shared.fetchAllLines(onlySelected: false, { (lines, _) in
            DispatchQueue.main.async {
                
                if let lines = lines {
                    self.teacherArray = Dictionary(uniqueKeysWithValues: lines.map { ($0.name, $0) })
                }
            }
        })
        
        UIApplication.shared.isIdleTimerDisabled = true
        
        getAllQuestions()
        getAllNotes()
        refreshDate()
        refresHour()
        topTimer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self,
                                        selector: #selector(ViewController.getAllInformations),
                                        userInfo: nil, repeats: true)
    }
    
    func verifyThatNeedActivateScreenSaver(with questions: [Question]) {
        if questions.count == 0 {
            guard self.screenSaverViewController == nil else {
                return
            }
            DispatchQueue.main.async {
                self.questionActivityIndicator.stopAnimating()
                self.noQuestions.isHidden = false
                if let screenSaver = self.screenSaverTimeInterval {
                    if Date().timeIntervalSince1970 - screenSaver >= 600 {
                        self.screenSaverTimeInterval = nil
                        self.performSegue(withIdentifier: "screenSaver", sender: nil)
                    }
                } else {
                    self.screenSaverTimeInterval = Date().timeIntervalSince1970
                }
            }
        } else {
            self.screenSaverTimeInterval = nil
            DispatchQueue.main.async {
                self.screenSaverViewController?.dismiss(animated: true, completion: {
                    self.screenSaverViewController = nil
                })
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "screenSaver" {
            self.screenSaverViewController = segue.destination as? ScreenSaverViewController
            self.screenSaverViewController?.screenDelegate = self
        }
    }
    
    func getAllQuestions() {
        questionService.retrieveAllOpenQuestions {[weak self] newQuestions in
            
            if let questions = newQuestions {
                if let vc = self {
                    if questions.count == 0 || vc.openedQuestions != questions {
                        
                        vc.openedQuestions.removeAll()
                        vc.openedQuestions = questions
                        DispatchQueue.main.async {
                            
                            vc.openedQuestions.removeAll()
                            vc.openedQuestions = questions
                            vc.questionTableView.reloadData()
                            vc.questionActivityIndicator.stopAnimating()
                            vc.developerNumber.text = String(vc.lineNumber(questions, condition: { (questionProfile) -> Bool in
                                return questionProfile.requestedTeacher == CategoryQuestionType.developer.rawValue
                            }))
                            vc.designNumber.text = String(vc.lineNumber(questions, condition: { (questionProfile) -> Bool in
                                return questionProfile.requestedTeacher == CategoryQuestionType.design.rawValue
                            }))
                            vc.businessNumber.text = String(vc.lineNumber(questions, condition: { (questionProfile) -> Bool in
                                return questionProfile.requestedTeacher == CategoryQuestionType.business.rawValue
                            }))
                            
                            vc.questionTableView.reloadData()
                            vc.questionActivityIndicator.stopAnimating()
                            if vc.openedQuestions.count == 0 {
                                vc.noQuestions.isHidden = false
                            } else {
                                vc.noQuestions.isHidden = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func lineNumber(_ questions: [QuestionProfile], condition: (QuestionProfile) -> Bool) -> Int {
        return questions.reduce(into: 0, { (result, question) in
            if condition(question) {
                result += 1
            }
        })
    }
    
    func getAllNotes() {
        
        noteService.retrieveOrderedNotes {[weak self] (noteProfile) in
            if let notes = noteProfile {
            
                    if notes.count == 0 || self?.openedNotes != notes {
                        self?.openedNotes.removeAll()
                        self?.openedNotes = notes
                        DispatchQueue.main.async {
                            self?.noteCollectionView.reloadData()
                            self?.noteCollectionView.collectionViewLayout.invalidateLayout()
                            self?.noteActivityIndicator.stopAnimating()
                            if self?.openedNotes.count == 0 {
                                self?.noNotes.isHidden = false
                            }
                            else {
                                self?.noNotes.isHidden = true
                            }
                        }
                    }
                
            }
        }
//        noteService.getAllQuestions(completion: {[weak self] (notes, error) in
//            if error == nil {
//                let notes = notes.sorted(by: { (note1, note2) -> Bool in
//                    return note1.noteID > note2.noteID
//                })
//                if notes.count == 0 || self?.openedNotes != notes {
//                    self?.openedNotes.removeAll()
//                    self?.openedNotes = notes
//                    DispatchQueue.main.async {
//                        self?.noteCollectionView.reloadData()
//                        self?.noteCollectionView.collectionViewLayout.invalidateLayout()
//                        self?.noteActivityIndicator.stopAnimating()
//                        if self?.openedNotes.count == 0 {
//                            self?.noNotes.isHidden = false
//                        }
//                        else {
//                            self?.noNotes.isHidden = true
//                        }
//                    }
//                }
//            }
//        })
    }
    
    
    @objc func getAllInformations() {
        getAllQuestions()
        getAllNotes()
        refreshDate()
        refresHour()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshDate() {
        self.dateLabel.text = Formatter.fullDateToString(Date())
    }
    
    func refresHour() {
        self.hourLabel.text = Formatter.currentHour()
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
        
        
        
        if self.openedQuestions.count > 0 {
            cell?.profileName.text = self.openedQuestions[indexPath.row].username
            cell?.questionLabel.text = self.openedQuestions[indexPath.row].questionTitle
            cell?.numberLabel.text = "\(indexPath.row + 1)"
            //cell?.viewTypeQuestion.backgroundColor = self.openedQuestions[indexPath.row].categoryQuestion.color
            
            let lineName = openedQuestions[indexPath.row].requestedTeacher
            if let line = teacherArray[lineName] {
                
                cell?.viewTypeQuestion.backgroundColor = UIColor(red: CGFloat(line.color.red), green: CGFloat(line.color.green), blue: CGFloat(line.color.blue), alpha: 1.0)
            }
            
            
            //Tirar o timestamp e colocar a data e hora
            if let date = openedQuestions[indexPath.row].createdAt {
                let strDate = Formatter.dateToString(date)
                cell?.timeInputQuestion.text = strDate
            }
            if(openedQuestions[indexPath.row].userPhoto != "") {
                //let photoUrl = URL(string: openedQuestions[indexPath.row].userPhoto)!
                //cell?.profileImage.kf.setImage(with: photoUrl)
            } else {
                cell?.profileImage.image = #imageLiteral(resourceName: "icons8-user_filled")
            }
            
            
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? QuestionTableViewCell
        //cell?.viewTypeQuestion.backgroundColor = self.openedQuestions[indexPath.row].categoryQuestion.color
    
        let lineName = openedQuestions[indexPath.row].requestedTeacher
        if let line = teacherArray[lineName] {
            
            cell?.viewTypeQuestion.backgroundColor = UIColor(red: CGFloat(line.color.red), green: CGFloat(line.color.green), blue: CGFloat(line.color.blue), alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return openedNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath)
        
        if let noteCell = cell as? NoteViewCell {
            noteCell.noteLabel.text = openedNotes[indexPath.row].noteText
            
            let strDate = Formatter.dateToString(openedNotes[indexPath.row].createdAt)
            
            noteCell.nameLabel.text = "João Silva"
            noteCell.dateLabel.text = "\(strDate)"
//            noteCell.configureWidth(screenWidth)
        }
        
        return cell
    }
    
}

extension ViewController: NoteCollectionViewLayoutDelegate {
    
    func calculeColumn(width: CGFloat) -> CGFloat {
        return width - (noteCollectionView.contentInset.left + noteCollectionView.contentInset.right) - 20
    }
    
    func getAllTexts() -> [String] {
        return self.openedNotes.reduce([], {result, element in
            var result = result
            result.append(element.noteText)
            return result
        })
    }

}

extension ViewController: ScreenSaverDelegate {
    
    func didDismiss() {
        self.screenSaverViewController = nil
    }
    
}
