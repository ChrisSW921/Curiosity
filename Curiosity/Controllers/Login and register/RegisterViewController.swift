//
//  RegisterViewController.swift
//  Curiosity
//
//  Created by Chris Withers on 6/24/20.
//  Copyright © 2020 Chris Withers. All rights reserved.
//

import UIKit
import Firebase
class RegisterViewController: UIViewController {

  
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else{
                    
                    self.performSegue(withIdentifier: "RegisterComplete", sender: self)
                }
            }
        }
    }

    


}
