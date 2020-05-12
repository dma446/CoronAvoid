//
//  HomeViewController.swift
//  CoronAvoid
//
//  Created 4/3/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import GoogleSignIn

class HomeViewController: UIViewController {
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var streakNum: UILabel!
    @IBOutlet weak var streakUnit: UILabel!
    
    var db: Firestore!
    
    let user = Auth.auth().currentUser!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if user?.uid == nil {
//            //print("Ah, man!")
//        } else {
//            //print("Hello, World!")
//        }
        
        //display current date
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM yyyy"
        let stringDate = formatter.string(from: currentDate)
        currentDateLabel.text = stringDate;
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        //pull date from user database and display day streak
        self.db = Firestore.firestore()
        let userRef = self.db.document("users/\(user.email!)")
        //        let lastTimeStamp: Timestamp?
        userRef.getDocument { (doc, err) in
            if let doc = doc, doc.exists {
                let lastTimeStamp = doc.get("dateLastLeft") as? Timestamp
                print("date received")
                let lastDate: Date = lastTimeStamp?.dateValue() ?? Date()
                let streakDays = Date().homeOffset(from: lastDate)
                self.streakNum.text = streakDays.0
                self.streakUnit.text = streakDays.1
            } else {
                print("date not found")
            }
        }
    }


}

extension Date {
    func homeOffset(from date: Date) -> (String, String) {
        if years(from: date)   == 1 { return ("1", "year")   }
        if years(from: date)   > 0 { return ("\(years(from: date))", "years")   }
        if months(from: date)   == 1 { return ("1", "month")   }
        if months(from: date)  > 0 { return ("\(months(from: date))", "months")  }
        if weeks(from: date)   == 1 { return ("1", "week")   }
        if weeks(from: date)   > 0 { return ("\(weeks(from: date))", "weeks")   }
        if days(from: date)   == 1 { return ("1", "day")   }
        if days(from: date)    > 0 { return ("\(days(from: date))", "days")    }
        if hours(from: date)   == 1 { return ("1", "hour")   }
        if hours(from: date)   > 0 { return ("\(hours(from: date))", "hours")   }
        return ("0", "hours")
    }
}
