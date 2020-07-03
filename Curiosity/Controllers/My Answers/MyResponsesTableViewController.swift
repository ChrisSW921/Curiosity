//
//  MyResponsesTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 7/2/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase
import SwipeCellKit

class MyResponsesTableViewController: UITableViewController {

    
    var currentQuestion = Question()
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion.answers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myResponses", for: indexPath) as! SwipeTableViewCell
        cell.textLabel!.numberOfLines = 0
        cell.accessoryType = currentQuestion.correctAnswer[indexPath.row].prefix(1) == "T" ? .checkmark : .none
        cell.backgroundColor = currentQuestion.usersWhoAnswered[indexPath.row] == Auth.auth().currentUser?.email  ? #colorLiteral(red: 0, green: 0.8104301691, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel!.text = currentQuestion.answers[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    

}
extension MyResponsesTableViewController: SwipeTableViewCellDelegate {
func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
    guard orientation == .right else { return nil }
    
    if Auth.auth().currentUser?.email == currentQuestion.usersWhoAnswered[indexPath.row] {
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            let aToRemove = self.currentQuestion.answers[indexPath.row]
            let uToRemove = self.currentQuestion.usersWhoAnswered[indexPath.row]
            let cAnswerToRemove = self.currentQuestion.correctAnswer[indexPath.row]
            self.currentQuestion.answers.remove(at: indexPath.row)
            self.currentQuestion.usersWhoAnswered.remove(at: indexPath.row)
            self.currentQuestion.correctAnswer.remove(at: indexPath.row)
            self.db.collection("Questions").document(self.currentQuestion.question).updateData(["Answers" :  FieldValue.arrayRemove([aToRemove])])
            self.db.collection("Questions").document(self.currentQuestion.question).updateData(["usersWhoAnswered" :  FieldValue.arrayRemove([uToRemove])])
            self.db.collection("Questions").document(self.currentQuestion.question).updateData(["CorrectAnswer" :  FieldValue.arrayRemove([cAnswerToRemove])])
        
    }
        deleteAction.image = UIImage(named: "TrashImage")

        return [deleteAction]
    }else {
        return nil
    }

    
}

func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    return options
}
}
