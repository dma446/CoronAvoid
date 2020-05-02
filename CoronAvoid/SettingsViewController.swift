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
        
        if (indexPath[0]==1 && indexPath[1]==1) {
            let signOutWarning = UIAlertController(title: "Sign out?", message: "Are you sure you'd like to sign out?", preferredStyle: .actionSheet)
            
            let signOutOK = UIAlertAction(title: "Yes, sign me out", style: .default, handler: {(action)->Void in
                self.signOutBtnPressed()
            })
            
            let cancelSignOut = UIAlertAction(title: "Cancel", style: .cancel) {(action)->Void in
                print("sign out cancelled")
            }
            
            signOutWarning.addAction(signOutOK)
            signOutWarning.addAction(cancelSignOut)
            self.present(signOutWarning, animated: true, completion: nil)
        }
        
        else if (indexPath[0]==1 && indexPath[1]==1) {
            let homeRemoveWarning = UIAlertController(title: "Remove home location?", message: "Are you sure you'd like to remove your home location? This will turn off geofencing.", preferredStyle: .actionSheet)
            
            let homeRemoveOK = UIAlertAction(title: "Yes", style: .default, handler: {(action)->Void in
//                self.signOutBtnPressed()
                print("home location removed")
            })
            
            let cancelHomeRemove = UIAlertAction(title: "Cancel", style: .cancel) {(action)->Void in
                print("removal cancelled")
            }
            
            homeRemoveWarning.addAction(homeRemoveOK)
            homeRemoveWarning.addAction(cancelHomeRemove)
            self.present(homeRemoveWarning, animated: true, completion: nil)
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

