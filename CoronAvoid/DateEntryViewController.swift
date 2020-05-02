//
//  DateEntryViewController.swift
//  CoronAvoid
//
//  Created by Joshua Zhong on 29/04/20.
//  Copyright © 2020 NYU. All rights reserved.
//


import UIKit
import FirebaseAuth
import GoogleSignIn
import Firebase

class DateEntryViewController: UIViewController {

    var db: Firestore!
    
    @IBOutlet weak var lastDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let currentDate = Date()
        self.lastDatePicker.maximumDate = currentDate
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //push new date to user account in database
        
        let newDate = lastDatePicker.date
        
        let user = Auth.auth().currentUser!
        self.db = Firestore.firestore()
        let userRef = self.db.document("users/\(user.email!)")
        userRef.updateData(["dateLastLeft": Timestamp(date: newDate)]) {
            (err) in
            if let err = err {
                print("error, date not updated: \(err.localizedDescription)")
                self.showDateErrorAlert()
            } else {
                print("date updated successfully")
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
    func showDateErrorAlert() {
        let alert = UIAlertController(title: "Something went wrong", message: "Please try again in a sec.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
