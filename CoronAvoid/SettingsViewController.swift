//
//  SettingsViewController.swift
//  CoronAvoid
//
//  Created 4/12/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func signOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.view.window?.rootViewController = signInVC
        self.view.window?.makeKeyAndVisible()
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.signOut()
        } catch let signOutError as NSError {
            print("Sign Out Error: %@", signOutError)
        }
    }
    
}

