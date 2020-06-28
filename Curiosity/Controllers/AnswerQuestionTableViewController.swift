//
//  AnswerQuestionTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/25/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase

class AnswerQuestionTableViewController: UITableViewController {
    
    var firstCell = ""
    
    var Answers: [Answer] = []
    
    var alreadyAnswered: [String] = []
    
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        var questionToAnswer = Answer()
        questionToAnswer.answer = "Q: \(firstCell)"
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
                            if question == self.firstCell {
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
    
    @IBAction func addAnswer(_ sender: UIBarButtonItem) {
        for item in Answers {
            if item.user == Auth.auth().currentUser?.email {
                alreadyAnswered.append("Not new!")
            }
        }
        if alreadyAnswered.count == 0 {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add a New Answer", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                self.db.collection("Answers").addDocument(data: ["Answer": textField.text!, "Question": self.firstCell, "User": Auth.auth().currentUser?.email, "Correct Answer": false])
                self.tableView.reloadData()
            }
            
            alert.addAction(action)
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Add a new Answer"
            }
            
            
            present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
            })
        }
        
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Answers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionsAnswers", for: indexPath)

        cell.textLabel!.numberOfLines = 0
        
        cell.textLabel!.text = Answers[indexPath.row].answer

        return cell
    }
    
    
}
