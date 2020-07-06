//
//  MyAnswersTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 7/2/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase

class MyAnswersTableViewController: UITableViewController {
    
    var myQuestionsAnswered: [Question] = []
    
    var currentSelectedQuestion = Question()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestions()
    }

    
    func loadQuestions() {
        db.collection("Questions")
                .addSnapshotListener { (querySnapshot, error) in
                self.myQuestionsAnswered = []
                if let e = error {
                    print("There was an issue retrieving data from firestore. \(e)")
                }else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for doc in snapshotDocuments {
                            let data = doc.data()
                            if let questionText = data["Question"] as? String, let categoryOfQ = data["Category"] as? String, let user = data["User"] as? String, let QsAnswers = data["Answers"] as? [String], let UsersWhoAnswered = data["usersWhoAnswered"] as? [String], let correctA = data["CorrectAnswer"] as? [String] {
                                var newQuestion = Question()
                                newQuestion.category = categoryOfQ
                                newQuestion.question = questionText
                                newQuestion.user = user
                                newQuestion.answers = QsAnswers
                                newQuestion.correctAnswer = correctA
                                newQuestion.usersWhoAnswered = UsersWhoAnswered
                                if newQuestion.usersWhoAnswered.contains((Auth.auth().currentUser?.email!)!) {
                                    self.myQuestionsAnswered.append(newQuestion)
                                }
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                }
                                
                            }
                        
                        }
                    }
                }
            }
        }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myQuestionsAnswered.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "myQuestion", for: indexPath)
        cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
        cell.accessoryType = .disclosureIndicator
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = myQuestionsAnswered[indexPath.row].question

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedQuestion = myQuestionsAnswered[indexPath.row]
        performSegue(withIdentifier: "goToMyAnswers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MyResponsesTableViewController
        destinationVC.currentQuestion = currentSelectedQuestion
    }


}
