//
//  DistanceViewController.swift
//  CoronAvoid
//
//  Created by Joshua Zhong on 15/04/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit

class DistanceViewController: UIViewController {

    @IBOutlet weak var beaconSwitch: UISwitch!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    var radarImage:UIImage?
    var isAnimating:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if beaconSwitch.isOn {
            isAnimating = true
        }
        else if !beaconSwitch.isOn {
            isAnimating = false
        }
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
    }
    
    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func beaconSwitchFlipped(_ sender: Any) {
        if beaconSwitch.isOn {
            isAnimating = true
            self.appDelegate?.sendNotification()
        }
        else {
            isAnimating = false
        }
    }
    
    
    @objc func onTimer() {
        if (isAnimating ?? false) {
            let radarImage = UIImage(named: "Beacon Ring")
            let radarImageView = UIImageView(image: radarImage)
            radarImageView.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
            radarImageView.center = self.view.center
            radarImageView.alpha = 1.0
            self.view.addSubview(radarImageView)
            self.view.sendSubviewToBack(radarImageView)
            UIView.animate(withDuration: 3, animations: {
                radarImageView.frame = CGRect(x: 0.0, y:(Double(self.screenHeight)/2)-(Double(self.screenWidth)/2), width: Double(self.screenWidth), height: Double(self.screenWidth))
                radarImageView.alpha = 0.0
            }) { (true) in
                radarImageView.removeFromSuperview()
            }
        }
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
