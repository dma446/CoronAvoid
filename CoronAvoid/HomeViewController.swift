//
//  HomeViewController.swift
//  CoronAvoid
//
//  Created 4/3/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if user?.uid == nil {
            //print("Ah, man!")
        } else {
            //print("Hello, World!")
        }
    }


}

