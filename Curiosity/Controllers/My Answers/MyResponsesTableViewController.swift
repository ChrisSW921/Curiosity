//
//  MyResponsesTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 7/2/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase

class MyResponsesTableViewController: UITableViewController {

    
    var currentQuestion = Question()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentQuestion.answers.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myResponses", for: indexPath)

        cell.accessoryType = currentQuestion.correctAnswer[indexPath.row].prefix(1) == "T" ? .checkmark : .none
        cell.backgroundColor = currentQuestion.usersWhoAnswered[indexPath.row] == Auth.auth().currentUser?.email ? #colorLiteral(red: 0, green: 0.8104301691, blue: 1, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cell.textLabel!.text = currentQuestion.answers[indexPath.row]

        return cell
    }
    

}
