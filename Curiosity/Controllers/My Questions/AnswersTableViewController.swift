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

    var currentQuestion = Question()

    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

    }



    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion.answers.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newAnswers: [String] = []
        for x in currentQuestion.correctAnswer{
            if currentQuestion.correctAnswer.firstIndex(of: x) == indexPath.row {
                if x.prefix(1) == "F"{
                    newAnswers.append("T \(currentQuestion.usersWhoAnswered[indexPath.row])")
                }else {
                    newAnswers.append("F \(currentQuestion.usersWhoAnswered[indexPath.row])")
                }
            }else {
                newAnswers.append(x)
            }
        }
        currentQuestion.correctAnswer = newAnswers
        db.collection("Questions").document(currentQuestion.question).updateData(["CorrectAnswer": newAnswers])
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestionsAnswers", for: indexPath)

        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = currentQuestion.answers[indexPath.row]
        cell.accessoryType = currentQuestion.correctAnswer[indexPath.row].prefix(1) == "T" ? .checkmark : .none

        return cell
    }

}
