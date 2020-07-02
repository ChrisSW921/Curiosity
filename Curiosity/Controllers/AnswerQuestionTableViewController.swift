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
    
    var currentQuestion = Question()
    
    var alreadyAnswered: [String] = []
    
    let db = Firestore.firestore()

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    
    @IBAction func addAnswer(_ sender: UIBarButtonItem) {
        for item in currentQuestion.usersWhoAnswered {
            if item == Auth.auth().currentUser?.email {
                alreadyAnswered.append("I've answered")
            }
        }
        if alreadyAnswered.count == 0 && Auth.auth().currentUser?.email != currentQuestion.user {
            var textField = UITextField()
            let alert = UIAlertController(title: "Add a New Answer", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Add", style: .default) { (action) in
                
                self.db.collection("Questions").document(self.currentQuestion.question).updateData(["Answers": FieldValue.arrayUnion([textField.text!])])
                self.db.collection("Questions").document(self.currentQuestion.question).updateData(["usersWhoAnswered": FieldValue.arrayUnion([Auth.auth().currentUser?.email])])
                self.db.collection("Questions").document(self.currentQuestion.question).updateData(["CorrectAnswer": FieldValue.arrayUnion(["F \(Auth.auth().currentUser!.email ?? "Nobody")"])])
                
                self.currentQuestion.answers.append(textField.text!)
                self.currentQuestion.correctAnswer.append("False")
                self.currentQuestion.usersWhoAnswered.append((Auth.auth().currentUser?.email)!)
                
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
        return currentQuestion.answers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionsAnswers", for: indexPath)

        cell.textLabel!.numberOfLines = 0
        
        cell.textLabel!.text = currentQuestion.answers[indexPath.row]
        cell.accessoryType = currentQuestion.correctAnswer[indexPath.row].prefix(1) == "T" ? .checkmark : .none
        
        return cell
    }
    
    
}
