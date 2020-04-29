//
//  ResourcesViewController.swift
//  CoronAvoid
//
//  Created by Joshua Zhong on 15/04/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class ResourcesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row \(indexPath) tapped")
        
        if (indexPath[0]==0 && indexPath[1]==0) {
            callNumber(phoneNumber: "911")
        }
        else if (indexPath[0]==0 && indexPath[1]==1) {
            if let url = URL(string: "https://www.hospitalstats.org/ER-Wait-Time/") {
                UIApplication.shared.open(url)
            }
        }
        else if (indexPath[0]==1 && indexPath[1]==0) {
            if let url = URL(string: "https://www.hopkinsmedicine.org/coronavirus/covid-19-self-checker.html") {
                UIApplication.shared.open(url)
            }
        }
        else if (indexPath[0]==1 && indexPath[1]==1) {
            if let url = URL(string: "https://www.cdc.gov/coronavirus/2019-ncov/symptoms-testing/symptoms.html") {
                UIApplication.shared.open(url)
            }
        }
        else if (indexPath[0]==2 && indexPath[1]==0) {
            if let url = URL(string: "https://www.cdc.gov/coronavirus/2019-ncov/index.html") {
                UIApplication.shared.open(url)
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    private func callNumber(phoneNumber:String) {

        if let phoneCallURL = URL(string: "telprompt://\(phoneNumber)") {

            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                     application.openURL(phoneCallURL as URL)

                }
            }
        }
    }
}
