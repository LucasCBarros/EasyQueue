////
////  ViewController.swift
////  FilaFacilTV
////
////  Created by Jessica Batista de Barros Cherque on 17/05/18.
////  Copyright © 2018 Lucas C Barros. All rights reserved.
////
//
//import UIKit
//import Kingfisher
//
//class ViewControllerOLD: UIViewController {
//
//    @IBOutlet weak var noteActivityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var noteCollectionView: UICollectionView!
//    @IBOutlet weak var questionActivityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var noQuestions: UILabel!
//    @IBOutlet weak var noNotes: UILabel!
//    @IBOutlet weak var questionTableView: UITableView!
//
//    //var questionService = QuestionService()
//    var questionService = QuestionProfileService()
//    var openedQuestions: [QuestionProfile] = []
//    var noteService = NoteService()
//    var openedNotes: [Note] = []
//    var topTimer: Timer!
//
//    var teacherArray: [PresentableLine] = []
//    var selectedTab: PresentableLine?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        if let layout = noteCollectionView.collectionViewLayout as? NoteCollectionViewLayout {
//            layout.delegate = self
//        }
//
//        UIApplication.shared.isIdleTimerDisabled = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//
//        LineService.shared.fetchAllLines(onlySelected: true, { (lines, _) in
//            DispatchQueue.main.async {
//                self.teacherArray = lines!
//                let existsSelected = self.teacherArray.contains(where: { (presentableLine) -> Bool in
//                    return self.selectedTab?.lineId == presentableLine.lineId
//                })
//                if !existsSelected {
//                    self.selectedTab = self.teacherArray.first
//                }
//                //self.linesCollectionView.reloadData()
//            }
//        })
//
//        getAllQuestions()
//        getAllNotes()
//        topTimer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self,
//                                                selector: #selector(ViewController.getAllInformations),
//                                                userInfo: nil, repeats: true)
//    }
//
//    func getAllQuestions() {
//
//        questionService.retrieveAllOpenQuestions { newQuestions in
//
//            if let questions = newQuestions {
//
//                if questions.count == 0 || self.openedQuestions != questions {
//                    self.openedQuestions.removeAll()
//                    self.openedQuestions = questions
//                    DispatchQueue.main.async {
//                        self.questionTableView.reloadData()
//                        self.questionActivityIndicator.stopAnimating()
//                        if self.openedQuestions.count == 0 {
//                            self.noQuestions.isHidden = false
//                        } else {
//                            self.noQuestions.isHidden = true
//                        }
//                    }
//                }
//            }
//        }
//
////        questionService.getAllQuestions(completion: {[weak self] (questions, error) in
////            if error == nil {
////                let questions = questions.sorted(by: { (question1, question2) -> Bool in
////                    return question1.questionID < question2.questionID
////                })
////                if questions.count == 0 || self?.openedQuestions != questions {
////                    self?.openedQuestions.removeAll()
////                    self?.openedQuestions = questions
////                    DispatchQueue.main.async {
////                        self?.questionTableView.reloadData()
////                        self?.questionActivityIndicator.stopAnimating()
////                        if self?.openedQuestions.count == 0 {
////                            self?.noQuestions.isHidden = false
////                        } else {
////                            self?.noQuestions.isHidden = true
////                        }
////                    }
////                }
////            }
////        })
//    }
//
//    func getAllNotes() {
//        noteService.getAllQuestions(completion: {[weak self] (notes, error) in
//            if error == nil {
//                let notes = notes.sorted(by: { (note1, note2) -> Bool in
//                    return note1.noteID < note2.noteID
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
//                        } else {
//                            self?.noNotes.isHidden = true
//                        }
//                    }
//                }
//            }
//        })
//    }
//
//    @objc func getAllInformations() {
//        getAllQuestions()
//        getAllNotes()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}
//
//// MARK: - TableView functions
//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//
//    // Number of cells
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return self.openedQuestions.count
//        return openedQuestions.count
//    }
//
//    // Shows tableView cells
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell") as? QuestionTableViewCell
//
//        if self.openedQuestions.count > 0 {
//            cell?.profileName.text = self.openedQuestions[indexPath.row].username
//            cell?.questionLabel.text = self.openedQuestions[indexPath.row].questionTitle
//            cell?.numberLabel.text = "\(indexPath.row+1)"
//            //cell?.viewTypeQuestion.backgroundColor = self.openedQuestions[indexPath.row].categoryQuestion.color
//
//            //Tirar o timestamp e colocar a data e hora
//            //let timeInterval = Double.init(self.openedQuestions[indexPath.row].questionID)
//            if let date = self.openedQuestions[indexPath.row].createdAt {
//                let strDate = Formatter.dateToString(date)
//                cell?.timeInputQuestion.text = strDate
//            }
//
//            if openedQuestions[indexPath.row].userPhoto != "" {
//                cell?.profileImage.image = #imageLiteral(resourceName: "icons8-user_filled")
//                // Corrigir código da foto para pegar do cache
//                //let photoUrl = URL(string: openedQuestions[indexPath.row].userPhoto!)
//                //cell?.profileImage.kf.setImage(with: photoUrl)
//            } else {
//                cell?.profileImage.image = #imageLiteral(resourceName: "icons8-user_filled")
//            }
//        }
//
//        return cell!
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as? QuestionTableViewCell
//
//        // Mudar essa lógica para apresentar cor da questão corretamente
//        let line = teacherArray[indexPath.row]
//
//        cell?.viewTypeQuestion.backgroundColor = UIColor(red: CGFloat(line.color.red), green: CGFloat(line.color.green), blue: CGFloat(line.color.blue), alpha: 1.0)
//        //self.openedQuestions[indexPath.row].requestedTeacher.categoryQuestion.color
//    }
//
//}
//
//extension ViewController: UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return openedNotes.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteCell", for: indexPath)
//
//        if let noteCell = cell as? NoteViewCell {
//            noteCell.noteLabel.text = openedNotes[indexPath.row].noteText
//
//            let strDate = Formatter.dateToString(openedNotes[indexPath.row].date)
//
//            noteCell.dateLabel.text = strDate
////            noteCell.configureWidth(screenWidth)
//        }
//
//        return cell
//    }
//
//}
//
//extension ViewController: NoteCollectionViewLayoutDelegate {
//
//    func calculeColumn(width: CGFloat) -> CGFloat {
//        return width - (noteCollectionView.contentInset.left + noteCollectionView.contentInset.right) - 20
//    }
//
//    func getAllTexts() -> [String] {
//        return self.openedNotes.reduce([], {result, element in
//            var result = result
//            result.append(element.noteText)
//            return result
//        })
//    }
//
//}
