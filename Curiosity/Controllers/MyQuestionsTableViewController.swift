//
//  MyQuestionsTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/24/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase

class MyQuestionsTableViewController: UITableViewController {
    
    var questions: [Question] = []
    
    let db = Firestore.firestore()
    
    var currentSelectedQuestion = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestions()
       
    }
    
    func loadQuestions() {
    db.collection("Questions")
            .addSnapshotListener { (querySnapshot, error) in
            self.questions = []
            if let e = error {
                print("There was an issue retrieving data from firestore. \(e)")
            }else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let questionText = data["Question"] as? String, let categoryOfQ = data["Category"] as? String, let user = data["User"] as? String, let correctAnswer = data["Correct Answer"] as? Bool {
                            var newQuestion = Question()
                            newQuestion.category = categoryOfQ
                            newQuestion.correctAnswer = correctAnswer
                            newQuestion.question = questionText
                            newQuestion.user = user
                            if user == Auth.auth().currentUser?.email {
                                self.questions.append(newQuestion)
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
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestions", for: indexPath)

        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = questions[indexPath.row].question

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSelectedQuestion = questions[indexPath.row].question
        performSegue(withIdentifier: "goToMyAnswers", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnswersTableViewController
        destinationVC.currentQuestion = currentSelectedQuestion
    }

}
