//
//  MyQuestionsTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/24/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit

class MyQuestionsTableViewController: UITableViewController {
    
    var questions = ["How to find index of item", "How to find vertex in graph"]

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return questions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyQuestions", for: indexPath)

        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.text = questions[indexPath.row]

        return cell
    }
    

}
