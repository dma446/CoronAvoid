//
//  UsernameViewController.swift
//  CoronAvoid
//
//  Created by David Acheampong on 04/27/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

class UsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
 
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func showUsernameTakenAlert() {
        let alert = UIAlertController(title: "Username taken!", message: "Please choose another username.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func returnUsername(sender: AnyObject) {
        let user = Auth.auth().currentUser!
        let usernameEntered = self.usernameTextField.text!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        self.db = Firestore.firestore()
        let userRef = self.db.document("users/\(user.email!)")
        
        //Checks if username is taken
        self.db.collection("users").whereField("username", isEqualTo:usernameEntered).getDocuments {
              (docs, err) in
            if let docs = docs, docs.isEmpty
            {//Username is free to use
                //Checks if user already exists
                userRef.getDocument {(document, error) in
                    if let document = document, document.exists {
                        userRef.updateData(["username": usernameEntered]) {
                            (err) in
                            if let err = err {
                                print("Oh noes!: \(err.localizedDescription)")
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    } else {
                        //If User doesn't exists, create new user
                        let userData: [String: Any] = ["username": usernameEntered, "timeHome":0]
                        userRef.setData(userData) {
                            (err) in
                            if let err = err {
                                print("Oh noes!: \(err.localizedDescription)")
                            } else {
                                self.view.window?.rootViewController = storyboard.instantiateViewController(identifier: "HomeViewController")
                                self.view.window?.makeKeyAndVisible()
                            }
                        }
                    }
                }
            }else {
                //Username is taken
                self.showUsernameTakenAlert()
            }
        }
    }
}

