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
    
    var questions = [Question(question: "No questions added yet")]
    var category = ""
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add a New Question", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            self.db.collection("Questions").addDocument(data: ["Question": textField.text!, "Category": self.category, "Answers": [], "User": Auth.auth().currentUser?.email])
            var newQuestion = Question()
            newQuestion.question = textField.text!
            newQuestion.category = self.category
            self.questions.append(newQuestion)
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
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Question", for: indexPath)
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = questions[indexPath.row].question

        return cell
    }
    
    
    
}
