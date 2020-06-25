//
//  QuestionsTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/24/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {

    private var lyst = ["Python", "Swift", "Xcode", "Java", "Javascript", "HTML", "CSS", "SASS", "Objective C", "PHP", "SQL", "MYSQL", "SQLite", "Realm", "C", "C#", "C++", "Shell", "Typescript", "Go", "Ruby", "Lua", "R", "Perl", "Kotlin", "Rust", "Scala", "Elixir", "Haskell"]
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return lyst.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "question", for: indexPath)
        cell.textLabel!.text = lyst[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    

}
 
