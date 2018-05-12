//
//  LineListViewController.swift
//  FilaFacil
//
//  Created by Lucas Barros on 23/02/18.
//  Copyright © 2018 Lucas C Barros. All rights reserved.
//

import UIKit

class LineListViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var customSegmentControl: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    // Array with all registered teachers
    var teacherArray = ["All", "Guga", "Sergio", "Cela", "Rosana", "Bia"]
    var selectedTab = "All"
    
    let userProfileManager = UserProfileService()
    let questionProfileManager = QuestionProfileService()
    var currentProfile: UserProfile?
    var allUserProfiles: [UserProfile]?
    var allQuestionProfiles: [QuestionProfile]?
    var usersInLine: [UserProfile]?
    var inLineQuestions: [QuestionProfile]?
    var refreshControl: UIRefreshControl!
    
    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        loadViewData()
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
    }
    
    // MARK: - Methods
    func refreshControlStart() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.tintColor = UIColor().UIGreen()
        listTableView.addSubview(refreshControl)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            cell?.profileName?.text = usersInLine![indexPath.row].username
            if let inLineQuestions = inLineQuestions {
                if inLineQuestions.count == (usersInLine?.count)! {
                    cell?.questionLabel?.text = inLineQuestions[indexPath.row].questionTitle
                }
            }
            
            if selectedTab == "All" {
//                userProfileManager.updateLinePosition(userID:usersInLine![indexPath.row].userID, position: indexPath.row+1 )
                if usersInLine![indexPath.row].userLinePosition != indexPath.row+1 {
                    cell?.numberLabel.text = "\(indexPath.row+1)"// Number in line
                } else {
                    cell?.numberLabel.text = "\(usersInLine![indexPath.row].userLinePosition)"// Number in line
                }
            } else {
                cell?.numberLabel.text = "\(usersInLine![indexPath.row].userLinePosition)"// Number in line
            }
        }
        
        // Cell apperance
        
        cell?.selectionStyle = .none // Removes selection
        cell?.profilePhoto.backgroundColor = UIColor.lightGray
        cell?.profilePhoto.alpha = 0.5
        cell?.profilePhoto.layer.cornerRadius = (cell?.profilePhoto.layer.frame.width)!/2
        cell?.profilePhoto.clipsToBounds = true
        cell?.numberLabel.layer.cornerRadius = (cell?.numberLabel.layer.frame.width)!/2
        cell?.numberLabel.layer.borderWidth = 0.5
        cell?.numberLabel.layer.borderColor = UIColor.gray.cgColor
        
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
//            listTableView.reloadData()
        }
    }
    
    // Allows to edit cell according to profile type
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if currentProfile?.profileType == "Teacher" {
            return true
        } else {
            return false
        }
    }
}

// MARK: - CollectionView functions
extension LineListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return teacherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentCell", for: indexPath) as? MainSegmentationCell
        
        cell?.segmentTitle.text = teacherArray[indexPath.row]
        cell?.segmentSelection.isHidden = true
        cell?.backgroundColor = UIColor().UIBlack()

        if selectedTab == teacherArray[indexPath.row] {
            cell?.backgroundColor = UIColor().UIGreen()
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // Remove Bg from previous cell
     
        if selectedTab == teacherArray[indexPath.row] {
            cell.backgroundColor = UIColor().UIGreen()
        } else {
            cell.backgroundColor = UIColor().UIBlack()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if selectedTab == teacherArray[indexPath.row] {
            cell.backgroundColor = UIColor().UIGreen()
        } else {
            cell.backgroundColor = UIColor().UIBlack()
        }
    }
    
    // Function to make border in selected item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // Remove Bg from previous cell
        for item in customSegmentControl.indexPathsForVisibleItems {
            let lastCell = collectionView.cellForItem(at: item)
            lastCell?.backgroundColor = UIColor().UIBlack()
        }

        // Color selected cell
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor().UIGreen()
        selectedTab = teacherArray[indexPath.row]

//        listTableView.reloadData()
        self.reloadViewData()
    }
}
