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


    @IBOutlet weak var points: UILabel!
    
    @IBOutlet weak var myAnswers: UILabel!

    var questions: [Question] = []

    let db = Firestore.firestore()

    var myQuestionsAnswered: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        loadQuestions()


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
                            if newQuestion.usersWhoAnswered.contains((Auth.auth().currentUser?.email)!) {
                                self.questions.append(newQuestion)
                            }
                            
                        }
                    
                    }
                    self.myAnswers.text = "Questions I've Answered: \(String(self.questions.count))"
                    
                    for item in self.questions {
                        for ans in item.correctAnswer{
                            if ans.prefix(1) == "T" && item.usersWhoAnswered[item.correctAnswer.firstIndex(of: ans)!] == Auth.auth().currentUser?.email{
                                self.myQuestionsAnswered += 1
                            }
                        }
                    }
                    self.points.text = "Points: \(String(self.myQuestionsAnswered))"
                }
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
