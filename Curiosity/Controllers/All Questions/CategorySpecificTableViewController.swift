//
//  CategorySpecificTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/24/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase

class CategorySpecificTableViewController: UITableViewController {
    
    var questions: [Question] = []
    
    var category = ""
    
    let db = Firestore.firestore()
    
    var currentCell: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestions()
       
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Question", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.db.collection("Questions").document(textField.text!).setData(["Question": textField.text!, "Category": self.category, "User": Auth.auth().currentUser?.email ?? "Nobody", "Answers": [], "usersWhoAnswered": [], "CorrectAnswer": []])
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new Question"
        }
        present(alert, animated: true, completion:{
        alert.view.superview?.isUserInteractionEnabled = true
        alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissOnTapOutside)))
        })
        
    }
    
    @objc func dismissOnTapOutside(){
       self.dismiss(animated: true, completion: nil)
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
                            if let questionText = data["Question"] as? String, let categoryOfQ = data["Category"] as? String, let user = data["User"] as? String, let QsAnswers = data["Answers"] as? [String], let UsersWhoAnswered = data["usersWhoAnswered"] as? [String], let correctA = data["CorrectAnswer"] as? [String] {
                                var newQuestion = Question()
                                newQuestion.category = categoryOfQ
                                newQuestion.question = questionText
                                newQuestion.user = user
                                newQuestion.answers = QsAnswers
                                newQuestion.correctAnswer = correctA
                                newQuestion.usersWhoAnswered = UsersWhoAnswered
                                if categoryOfQ == self.category {
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
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question", for: indexPath)
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = questions[indexPath.row].question
        cell.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentCell = indexPath.row
        self.performSegue(withIdentifier: "goToAnswers", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnswerQuestionTableViewController
        destinationVC.currentQuestion = questions[currentCell]
    }
    
    
    
}
