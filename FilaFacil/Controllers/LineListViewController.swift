//
//  LineListViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

//selectedTab = teacherArray[indexPath.row]

class LineListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var linesCollectionView: UICollectionView!
    
    // MARK: - Properties
    // Array with all registered teachers
    var teacherArray: [PresentableLine] = []
    var lineTotalWidth: CGFloat = 0
    var selectedTab: PresentableLine?
    
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    let userProfileManager = UserProfileService()
    let questionProfileManager = QuestionProfileService()
    var currentProfile: UserProfile?
    var allUserProfiles: [UserProfile]?
    var inLineQuestions: [QuestionProfile] = []
    var refreshControl: UIRefreshControl!
    
//    var queueOperation = DispatchQueue.global(qos: .)
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        LineService.shared.fetchAllLines(onlySelected: true, { (lines, _) in
            DispatchQueue.main.async {
                self.teacherArray = lines!
                let existsSelected = self.teacherArray.contains(where: { (presentableLine) -> Bool in
                    return self.selectedTab?.lineId == presentableLine.lineId
                })
                if !existsSelected {
                    self.selectedTab = self.teacherArray.first
                }
                self.linesCollectionView.reloadData()
            }
        })
//        self.teacherArray = Array(PresentedLinesService.shared.lines.sorted(by: { (line1, line2) -> Bool in
//            return line1 > line2
//        }))
    }

    func loadViewData() {
        self.activityIndicator.startAnimating()
        
        self.retrieveCurrentUserProfile()
        self.reloadViewData()
    }
    
    func reloadViewData() {
        if let selectedTab = self.selectedTab {
            self.retrieveAllQuestions(lineName: selectedTab.name)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControlStart()
        linesCollectionView.setNeedsLayout()
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Methods
    func refreshControlStart() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        listTableView.addSubview(refreshControl)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "newQuestionView" {
            if let view = segue.destination as? NewQuestionViewController {
                view.delegate = self
            }
        }
    }
    
    @objc func refreshTableView(refreshControl: UIRefreshControl) {
        if let selectedTab = self.selectedTab {
            self.retrieveAllQuestions(lineName: selectedTab.name)
        }
        refreshControl.endRefreshing()
    }
    
    // Retrieve logged user
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            if let userProfile = userProfile {
                self.currentProfile = userProfile
                self.userProfileManager.attualizeTokenID(user: userProfile)
            }
        }
    }
    
    func retrieveAllQuestions(lineName: String) {
        questionProfileManager.retrieveAllOpenQuestions(lineName: lineName) { (questionProfile) in
            if let questionProfile = questionProfile {
                // Add to main Thread
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    if self.selectedTab?.name == lineName {
                        let inLineQuestions = questionProfile.sorted { $0.questionID < $1.questionID }
                        if self.inLineQuestions != inLineQuestions {
                            self.inLineQuestions = inLineQuestions
                            self.listTableView.reloadData()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - TableView functions
extension LineListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (inLineQuestions.count)
    }
    
    // Shows tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as? MainListCell
        
        // Check if there are questions in Line
        if inLineQuestions.count >= indexPath.row - 1 {
            
            let question = inLineQuestions[indexPath.row]
            cell?.profileName?.text = question.username
            cell?.questionLabel?.text = question.questionTitle
            
            //Tirar o timestamp e colocar a data e hora
            let timeInterval = Double.init(question.questionID)
            let date = Date(timeIntervalSince1970: timeInterval! / 1000)
            let strDate = Formatter.dateToString(date)
            cell?.dateLabel.text = strDate
            if let url = URL(string: question.userPhoto) {
                
                KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: {[weak self] image, erro, _, url in
                    DispatchQueue.main.async {
                        if self != nil {
                            if let image = image, let url = url, erro == nil {
                                if self!.inLineQuestions.count > indexPath.row - 1 && url.absoluteString == self!.inLineQuestions[indexPath.row].userPhoto {
                                    cell?.profilePhoto.image = image
                                } else {
                                    cell?.profilePhoto.image = #imageLiteral(resourceName: "icons8-user_filled")
                                }
                            } else {
                                cell?.profilePhoto.image = #imageLiteral(resourceName: "icons8-user_filled")
                            }
                        }
                    }
                })
                
            } else {
                if self.inLineQuestions.count >= indexPath.row - 1 && question.userPhoto == self.inLineQuestions[indexPath.row].userPhoto {
                    cell?.profilePhoto.image = #imageLiteral(resourceName: "icons8-user_filled")
                }
            }
            
        }
        
        // Cell apperance
        cell?.selectionStyle = .none // Removes selection
        cell?.profilePhoto.backgroundColor = UIColor.lightGray
        cell?.profilePhoto.alpha = 0.5
        cell?.profilePhoto.layer.cornerRadius = (cell?.profilePhoto.layer.frame.width)!/2
        cell?.profilePhoto.clipsToBounds = true
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let editAction = UITableViewRowAction(style: .normal, title: "Editar", handler: { (rowAction, indexPath) in
//
//        })
//        editAction.backgroundColor = #colorLiteral(red: 0.3490196078, green: 0.3490196078, blue: 0.8274509804, alpha: 1)
        
        let deleteAction = UITableViewRowAction.init(style: .destructive, title: "Deletar", handler: {[weak self] (_, indexPath) in
            // update line status in Firebase
            if let this = self, this.inLineQuestions.count > 0, let selectedTab = this.selectedTab {
                let alert = UIAlertController(title: "Excluir da Fila", message: "Tem certeza que deseja excluir o assunto da fila de \(this.selectedTab!.name)?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Excluir", style: .destructive, handler: { _ in
                    let question = this.inLineQuestions[indexPath.row]
                    this.userProfileManager.removeQuestionFromLine(lineName: selectedTab.name, questionID: question.questionID)
                    // Reload View
                    DispatchQueue.main.async {
                        this.viewWillAppear(true)
                    }
                }))
                this.present(alert, animated: true, completion: nil)
            }
        })
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        
        var actions: [UITableViewRowAction] = []
        
        if self.inLineQuestions[indexPath.row].userID == self.currentProfile?.userID {
//            actions.append(editAction)
        }
        actions.append(deleteAction)
        
        return actions
    }
    
    // Allows to edit cell according to profile type
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.inLineQuestions[indexPath.row].userID == currentProfile?.userID {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            return true
        } else if currentProfile?.profileType == "Teacher" {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension LineListViewController: NewQuestionTableViewDelegate {
    
    func selectedLine() -> String {
        return self.selectedTab?.name ?? ""
    }
    
    func saveQuestion(text: String, selectedTeacher: String) {
        // Inserts question info in Firebase and updates users status
        questionProfileManager.createQuestion(userID: currentProfile!.userID, questionTxt: text,
                                              username: currentProfile!.username,
                                              requestedTeacher: selectedTeacher,
                                              userPhoto: (self.currentProfile?.photo)!)
    }
    
}

// MARK: - Lines
extension LineListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.lineTotalWidth = 0
        return teacherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lineCell", for: indexPath)
        
        if let lineCell = cell as? LineCell {
            let line = teacherArray[indexPath.row]
            lineCell.title.text = line.name
            if lineCell.title.text == selectedTab?.name {
                lineCell.colorfulBar.backgroundColor = UIColor(red: CGFloat(line.color.red), green: CGFloat(line.color.green), blue: CGFloat(line.color.blue), alpha: 1.0)
            } else {
                lineCell.colorfulBar.backgroundColor = UIColor.clear
            }
        }
        
        if indexPath.row == indexPath.last {
            self.loadViewData()
        }
        
        return cell
    }
    
}

extension LineListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedTab = teacherArray[indexPath.row]
        self.loadViewData()
        self.linesCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let heitgh: CGFloat = 45.0
        var size = CGSize(width: 0, height: heitgh)
        if self.teacherArray.count > 2 {
            let width = teacherArray[indexPath.row].name.width(withConstrainedHeight: heitgh, font: UIFont(name: "SFProText-Medium", size: 17)!) + 30
            size.width = width
        } else {
            let width = (collectionView.frame.width / CGFloat(self.teacherArray.count))
            size.width = width
        }
        self.lineTotalWidth += size.width
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.teacherArray.count > 1 {
            let interitemSpacing = (collectionView.frame.width - self.lineTotalWidth) / CGFloat(self.teacherArray.count - 1)
            let minimumInteritemSpacing: CGFloat = 20.0
            return (minimumInteritemSpacing > interitemSpacing) ? minimumInteritemSpacing : interitemSpacing
        } else {
            return 0
        }
    }
    
}
