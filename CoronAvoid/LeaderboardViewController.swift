//
//  LeaderboardViewController.swift
//  CoronAvoid
//
//  Created by Joshua Zhong on 15/04/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LeaderboardViewController: UIViewController {
    
    //Leaderboard usernames
    @IBOutlet weak var userPosition1: UILabel!
    @IBOutlet weak var userPosition2: UILabel!
    @IBOutlet weak var userPosition3: UILabel!
    @IBOutlet weak var userPosition4: UILabel!
    @IBOutlet weak var userPosition5: UILabel!
    @IBOutlet weak var userPosition6: UILabel!
    @IBOutlet weak var userPosition7: UILabel!
    @IBOutlet weak var userPosition8: UILabel!
    @IBOutlet weak var userPosition9: UILabel!
    @IBOutlet weak var userPosition10: UILabel!
    
    //Leaderboard scores
    @IBOutlet weak var scorePosition1: UILabel!
    @IBOutlet weak var scorePosition2: UILabel!
    @IBOutlet weak var scorePosition3: UILabel!
    @IBOutlet weak var scorePosition4: UILabel!
    @IBOutlet weak var scorePosition5: UILabel!
    @IBOutlet weak var scorePosition6: UILabel!
    @IBOutlet weak var scorePosition7: UILabel!
    @IBOutlet weak var scorePosition8: UILabel!
    @IBOutlet weak var scorePosition9: UILabel!
    @IBOutlet weak var scorePosition10: UILabel!

    var userLabelList: [UILabel] = []
    var scoreLabelList: [UILabel] = []
    
    var db: Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
       // let user = Auth.auth().currentUser
        userLabelList = [userPosition1, userPosition2, userPosition3, userPosition4, userPosition5, userPosition6, userPosition7, userPosition8, userPosition9, userPosition10]
        scoreLabelList = [scorePosition1, scorePosition2, scorePosition3, scorePosition4, scorePosition5, scorePosition6, scorePosition7, scorePosition8, scorePosition9, scorePosition10]
        
        var users = ["", "", "", "", "", "", "", "", "", ""]
        var scores = ["", "", "", "", "", "", "", "", "", ""]
        
        db = Firestore.firestore()
        
        db.collection("users").order(by: "timeHome").limit(to: 10).addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Snapshot retreival error! \(error!)")
                return
            }
            var i = 0
            for doc in querySnapshot.documents{
                users.insert("\(doc.get("username")!)", at: i)
                scores.insert("\(doc.get("timeHome")!)", at: i)
                i += 1
            }
            
            for i in 0...9 {
                self.userLabelList[i].text = users[i]
                self.scoreLabelList[i].text = scores[i]
            }
        }
    }
    
    @IBAction func closeVC(_ sender: Any) {
        [self .dismiss(animated: true, completion: nil)]
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
