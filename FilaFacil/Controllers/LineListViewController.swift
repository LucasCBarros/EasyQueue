//
//  LineListViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit
import Firebase

//selectedTab = teacherArray[indexPath.row]

class LineListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var questionTypeSegmentation: OurSegmentedControl!
    
    // MARK: - Properties
    // Array with all registered teachers
    let teacherArray = ["Developer", "Design", "Business"]
    var selectedTab = "Developer"
    
    let storageRef = Storage.storage().reference()
    let databaseRef = Database.database().reference()
    
    let userProfileManager = UserProfileService()
    let questionProfileManager = QuestionProfileService()
    var currentProfile: UserProfile?
    var allUserProfiles: [UserProfile]?
    var allQuestionProfiles: [QuestionProfile]?
    var usersInLine: [UserProfile]?
    var inLineQuestions: [QuestionProfile]?
    var refreshControl: UIRefreshControl!
    
    // MARK: - Actions
    @IBAction func segmentationAction(_ sender: UISegmentedControl) {
        self.selectedTab = self.teacherArray[sender.selectedSegmentIndex]
        self.loadViewData()
    }
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        loadViewData()
        questionTypeSegmentation.layer.cornerRadius = 4.5
        let font = UIFont.systemFont(ofSize: 15, weight: .bold)
        var titleTextAttributes: [AnyHashable: Any] = [:]
        titleTextAttributes[NSAttributedStringKey.font] = font
        titleTextAttributes[kCTForegroundColorAttributeName] = UIColor.white
        questionTypeSegmentation.setTitleTextAttributes(titleTextAttributes, for: .normal)
    }

    func loadViewData() {
        self.activityIndicator.startAnimating()
        
        self.retrieveCurrentUserProfile()
        self.reloadViewData()
        
        if usersInLine?.first?.userLinePosition != 1 {
            reloadViewData()
        }
    }
    
    func reloadViewData() {
        self.retrieveAllUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControlStart()
        questionTypeSegmentation.delegate = self
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
        self.retrieveAllUsers()
        refreshControl.endRefreshing()
    }
    
    // Order list of elements by QuestionID
    func orderListElements() {
        usersInLine = usersInLine?.sorted { $0.questionID < $1.questionID }
        inLineQuestions = inLineQuestions?.sorted { $0.questionID < $1.questionID }
        if selectedTab == "All" {
            self.addLinePosition()
        }
    }
    
    func addLinePosition() {
        if usersInLine != nil {
            let numberOfUsers: Int = usersInLine!.count
            
            for user in (0..<numberOfUsers) {
                userProfileManager.updateLinePosition(userID: usersInLine![user].userID, position: user+1)
            }
        }
    }
    
    func filterListByTab() {
        if selectedTab != "All" {
            self.retrieveAllUsersInLine()
            self.retrieveAllQuestionsInLine()
            
            // Protective code against Nil values
            var currentQuestions: [QuestionProfile] = []
            if inLineQuestions != nil {
                currentQuestions = self.inLineQuestions!
            }
            
            let (newUsers, newQuestions) = userProfileManager.filterLineByTab(
                allUsers: self.usersInLine!,
                allQuestions: currentQuestions,
                selectedTab: selectedTab)
            
            self.usersInLine = newUsers
            self.inLineQuestions = newQuestions
            
            orderListElements()
            
            listTableView.reloadData()
        }
    }
    
    // Retrieve logged user
    func retrieveCurrentUserProfile() {
        userProfileManager.retrieveCurrentUserProfile { (userProfile) in
            if let userProfile = userProfile {
                self.currentProfile = userProfile
            }
        }
    }
    
    // Retrieve all users registered in Firebase
    func retrieveAllUsers() {
        userProfileManager.retrieveAllUsersInLine { (userProfile) in
            if let userProfile = userProfile {
                self.allUserProfiles = userProfile
            }
            
            // Filters returned users array
            self.retrieveAllUsersInLine()
            
            // Add to main Thread
            DispatchQueue.main.async {
                self.retrieveAllQuestions()
            }
        }
    }
    
    // Filters AllUsers array for users in line
    func retrieveAllUsersInLine() {
        if self.allUserProfiles != nil {
            self.usersInLine = self.userProfileManager.filterUsersInLine(allUsers: self.allUserProfiles!)
        }
    }
    
    // Retrieve all questions registered in Firebase
    func retrieveAllQuestions() {
        questionProfileManager.retrieveAllOpenQuestions { (questionProfile) in
            if let questionProfile = questionProfile {
                self.inLineQuestions = questionProfile
            }
            
            // Filter questions for each user in the line
            self.retrieveAllQuestionsInLine()
            
            // Add to main Thread
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.orderListElements()
                self.filterListByTab()
                self.listTableView.reloadData()
            }
        }
    }
    
    func retrieveAllQuestionsInLine() {
        if self.allQuestionProfiles != nil {
            self.inLineQuestions = self.questionProfileManager.filterQuestionsInLine(
                allUsers: self.usersInLine!,
                allQuestions: self.allQuestionProfiles!)
        }
    }
}

// MARK: - TableView functions
extension LineListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // Number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if usersInLine != nil {
            return (usersInLine?.count)!
        } else {
            return 0
        }
    }
    
    // Shows tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell") as? MainListCell
       
        if usersInLine != nil {
            // Gets users Profile
            databaseRef.child("Users").child(usersInLine![indexPath.row].userID).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dict = snapshot.value as? [String: AnyObject] {
                    if let profileImageURL = dict["photo"] as? String {
                        let url = URL(string: profileImageURL)
                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, _, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            DispatchQueue.main.async {
                                cell?.profilePhoto?.image = UIImage(data: data!)
                            }
                        }).resume()
                    }
                }
            })
            
            // Get users questions
            cell?.profileName?.text = usersInLine![indexPath.row].username
            if let inLineQuestions = inLineQuestions {
                if inLineQuestions.count == (usersInLine?.count)! {
                    cell?.questionLabel?.text = inLineQuestions[indexPath.row].questionTitle
                    //Tirar o timestamp e colocar a data e hora
                    let timeInterval = Double.init(inLineQuestions[indexPath.row].questionID)
                    let date = Date(timeIntervalSince1970: timeInterval! / 1000)
                    let strDate = Formatter.dateToString(date)
                    cell?.dateLabel.text = strDate
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
    
    // Delete cell and update student status in Firebase
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
            // update student status in Firebase
            if (usersInLine?.count)! > 0 {
                userProfileManager.removeUserFromLine(userID: usersInLine![indexPath.row].userID,
                                                      questionID: inLineQuestions![indexPath.row].questionID)
            }
            // Reload View
            viewWillAppear(true)
        }
    }
    
    // Allows to edit cell according to profile type
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.inLineQuestions?[indexPath.row].userID == currentProfile!.userID || currentProfile?.profileType == "Teacher" {
            return true
        } else {
            return false
        }
    }
}

extension LineListViewController: NewQuestionTableViewDelegate {
    
    func saveQuestion(text: String, selectedTeacher: String) {
        // Inserts question info in Firebase and updates users status
        questionProfileManager.createQuestion(userID: currentProfile!.userID, questionTxt: text,
                                              username: currentProfile!.username,
                                              requestedTeacher: selectedTeacher,
                                              positionInLine: (usersInLine?.count)!+1)
    }
    
}

extension LineListViewController: OurSegmentedControlDelegate {
    
    func tintColorFor(_ index: Int, isSelected: Bool) -> UIColor? {
        if !isSelected {
            return UIColor.white
        }
        switch index {
        case 0:
            return UIColor.developer()
        case 1:
            return UIColor.design()
        case 2:
            return UIColor.business()
        default:
            return nil
        }
    }
    
    func backgroundColorFor(_ index: Int, isSelected: Bool) -> UIColor? {
        return UIColor.white
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}
