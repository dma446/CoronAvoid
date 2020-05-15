//
//  SignInViewController.swift
//  CoronAvoid
//
//  Created by David Acheampong on 04/11/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInDelegate {
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    var db: Firestore!
    var nextVC:UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        //firebase authentication
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func signIn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let user = Auth.auth().currentUser!
        db = Firestore.firestore()
        let userRef = db.document("users/\(user.email!)")
        
        userRef.getDocument {(document, error) in
            if let document = document, document.exists {
                self.nextVC = storyboard.instantiateViewController(identifier: "HomeViewController")
            } else {
                // go to UsernameVC if no username set up
                self.nextVC = storyboard.instantiateViewController(identifier: "UsernameViewController")
            }
            self.view.window?.rootViewController = self.nextVC
            self.view.window?.makeKeyAndVisible()
        }
    }

    @IBAction func googleSignInBtnPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
  
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        guard let auth = user.authentication else { return }
        let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.signIn()
            }
        }
    }
    
}


