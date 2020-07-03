//
//  QuestionsTableViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/24/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit

class QuestionsTableViewController: UITableViewController {
    
    var selectedCategory: String?

    private var lyst = ["Politics", "Food", "Lover", "Animals", "Work", "School", "Cars", "Technology", "Money", "Religion", "Family", "Friends", "Housing", "Sports", "Mental illness", "Physical illness", "Law", "Drugs", "Writing"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lyst.sort()

    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lyst.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
        cell.textLabel!.text = lyst[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "CategorySpecific", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategorySpecificTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
        destinationVC.category = lyst[indexPath.row]
        }
    }
    

}
 
