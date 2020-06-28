//
//  MyProfileViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/26/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UIViewController {

    
    
    @IBOutlet weak var myAnswers: UILabel!
    
    
    let db = Firestore.firestore()
    
    var myQuestionsAnswered: [Answer] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findQuestionsAnswered()
        
        
        
        
        
        
        
    }
    
    func findQuestionsAnswered () {
            db.collection("Answers")
                .addSnapshotListener { (querySnapshot, error) in
                    if let e = error {
                        print("There was an issue retrieving data from firestore. \(e)")
                    }else {
                        if let snapshotDocuments = querySnapshot?.documents {
                            for doc in snapshotDocuments {
                                let data = doc.data()
                                if let answerText = data["Answer"] as? String, let question = data["Question"] as? String, let user = data["User"] as? String, let correctAnswer = data["Correct Answer"] as? Bool {
                                    var newAnswer = Answer()
                                    newAnswer.question = question
                                    newAnswer.correctAnswer = correctAnswer
                                    newAnswer.answer = "A: \(answerText)"
                                    newAnswer.user = user
                                    if user == Auth.auth().currentUser?.email {
                                        self.myQuestionsAnswered.append(newAnswer)
                                        
                                    }
                                    
                                }
                            }
                        }
                        //self.questionsAnswered.text = String(self.myQuestionsAnswered.count)
                        self.myAnswers.text = "My Questions Answered: \(String(self.myQuestionsAnswered.count))"
                    }
            }
        
    }

    @IBAction func logoutPressed(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        
    }


}
