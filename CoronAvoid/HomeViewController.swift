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
    @IBOutlet weak var currentDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Auth.auth().currentUser
        if user?.uid == nil {
            //print("Ah, man!")
        } else {
            //print("Hello, World!")
        }
        
        //display current date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        let stringDate = formatter.string(from: currentDate)
        currentDateLabel.text = stringDate;
        
        //pull date from user database and display day streak
        
        
        
        
        
    }


}

