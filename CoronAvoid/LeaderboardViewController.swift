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
        
        db.collection("users").order(by: "dateLastLeft").limit(to: 10).addSnapshotListener { querySnapshot, error in
            guard let querySnapshot = querySnapshot else {
                print("Snapshot retreival error! \(error!)")
                return
            }
            var i = 0
            for doc in querySnapshot.documents{
                users.insert("\(doc.get("username")!)", at: i)
               
                let copiedTimeStamp = doc.get("dateLastLeft") as! Timestamp
                let lbDate = copiedTimeStamp.dateValue()
                let dateString = Date().lbOffset(from: lbDate)
                scores.insert(dateString, at: i)
                i += 1
            }
            
            for i in 0...9 {
                self.userLabelList[i].text = users[i]
                self.scoreLabelList[i].text = scores[i]
            }
        }
    }
    
    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
//    /// Returns the amount of minutes from another date
//    func minutes(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
//    }
//    /// Returns the amount of seconds from another date
//    func seconds(from date: Date) -> Int {
//        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
//    }
    /// Returns the a custom time interval description from another date
    func lbOffset(from date: Date) -> String {
        if years(from: date)   == 1 { return "1 year"   }
        if years(from: date)   > 0 { return "\(years(from: date)) years"   }
        if months(from: date)   == 1 { return "1 month"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months"  }
        if weeks(from: date)   == 1 { return "1 week"   }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks"   }
        if days(from: date)   == 1 { return "1 day"   }
        if days(from: date)    > 0 { return "\(days(from: date)) days"    }
        if hours(from: date)   == 1 { return "1 hour"   }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours"   }
//        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
//        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return "0 hours"
    }
}
    

