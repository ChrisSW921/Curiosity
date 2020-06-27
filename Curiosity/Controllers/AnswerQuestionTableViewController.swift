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
    
    var answers: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        var questionToAnswer = "Question: \(firstCell)"
        answers.append(questionToAnswer)
        print(answers)

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel!.numberOfLines = 0

        return cell
    }
    
    
}
