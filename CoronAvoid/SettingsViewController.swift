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

class SettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row \(indexPath) tapped")
        
        if (indexPath[0]==2 && indexPath[1]==0) {
            signOutBtnPressed()
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func signOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
        self.view.window?.rootViewController = signInVC
        self.view.window?.makeKeyAndVisible()
    }
    
    func signOutBtnPressed() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.signOut()
        } catch let signOutError as NSError {
            print("Sign Out Error: %@", signOutError)
        }
    }
    
}

