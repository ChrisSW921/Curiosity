//
//  AnswersTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/25/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase

class AnswersTableViewController: UITableViewController {

    var currentQuestion = ""
    
    var Answers: [Answer] = []
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var questionToAnswer = Answer()
        questionToAnswer.answer = "Q: \(currentQuestion)"
        var divider = Answer()
        divider.answer = "--------------------------------"
        Answers.append(questionToAnswer)
        Answers.append(divider)
        loadQuestions()

    }
    
    
    func loadQuestions() {
    db.collection("Answers")
            .addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from firestore. \(e)")
            }else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let answerText = data["Answer"] as? String, let question = data["Question"] as? String, let user = data["User"] as? String, let correctAnswer = data["Correct Answer"] as? Bool {
                            var newAnswer = Answer()
                            newAnswer.question = question
                            newAnswer.correctAnswer = correctAnswer
                            newAnswer.answer = "A: \(answerText)"
                            newAnswer.user = user
                            if question == self.currentQuestion {
                                self.Answers.append(newAnswer)
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
        return Answers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestionsAnswers", for: indexPath)

        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = Answers[indexPath.row].answer

        return cell
    }
    
}
