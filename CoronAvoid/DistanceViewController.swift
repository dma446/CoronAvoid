//
//  DistanceViewController.swift
//  CoronAvoid
//
//  Created by Joshua Zhong on 15/04/20.
//  Copyright © 2020 NYU. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import AudioToolbox
import AVFoundation
import FirebaseAuth
import GoogleSignIn
import Firebase

class DistanceViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {
    
    var db: Firestore!

    @IBOutlet weak var beaconSwitch: UISwitch!
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    public var screenWidth: CGFloat {
        return self.view.frame.size.width
    }
    public var screenHeight: CGFloat {
        return self.view.frame.size.height
    }
    
    var radarImage:UIImage?
    var isAnimating:Bool?
    
    var coughPlayer = AVAudioPlayer()
    
    var locationManager: CLLocationManager!
    var peripheral : CBPeripheralManager!
    
    var uuid : UUID!
    var major : CLBeaconMajorValue!
    var minor : CLBeaconMinorValue!
    var power : NSNumber!
    let beaconID = "com.CoronAvoid"
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state{
            case .poweredOff:
                if(peripheral.isAdvertising){
                    peripheral.stopAdvertising()
                }
            case .poweredOn:
                let myRegion = createBeaconRegion()!
                advertiseDevice(region: myRegion)
            default:
                locationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.shared.isIdleTimerDisabled = true
        
        isAnimating = false
        beaconSwitch.setOn(false, animated: false)
        
        // set up beacon
        locationManager = CLLocationManager()
        locationManager.delegate = self
        peripheral = CBPeripheralManager()
        peripheral.delegate = self
        power = nil
        uuid = UUID(uuidString: "7959A986-DC83-413A-B22E-EBE8B3606B42")
        major = 100
        minor = 1
        
        // set up animation
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        
        // set up sound
        let coughPath = Bundle.main.path(forResource: "cough", ofType:"wav")!
        do{
        coughPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: coughPath))
        }catch{
        print(error.localizedDescription)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    @IBAction func closeVC(_ sender: Any) {
        beaconSwitch.setOn(false, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func beaconSwitchFlipped(_ sender: Any) {
        if beaconSwitch.isOn {
            isAnimating = true
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            
            // request and turn on location services
            if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedAlways){
                locationManager.requestAlwaysAuthorization()
            }
            // start advertising
            if(CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                startScanning()
                if(!peripheral.isAdvertising){
                    advertiseDevice(region: createBeaconRegion()!)
                }
            }
            
            // update db timestamp
            let newDate = Date()
            
            let user = Auth.auth().currentUser!
            self.db = Firestore.firestore()
            let userRef = self.db.document("users/\(user.email!)")
            userRef.updateData(["dateLastLeft": Timestamp(date: newDate)]) {
                (err) in
                if let err = err {
                    print("error, date not updated: \(err.localizedDescription)")
                } else {
                    print("date updated successfully")
                }
            }
            
        }
        else {
            isAnimating = false
            if(peripheral.isAdvertising){
                peripheral.stopAdvertising()
            }
            locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor))
            }
    }
    
    
    @objc func onTimer() {
        // run animation
        if (isAnimating ?? false) {
            let radarImage = UIImage(named: "Beacon Ring")
            let radarImageView = UIImageView(image: radarImage)
            radarImageView.frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
            radarImageView.center = CGPoint(x: (screenWidth/2), y: (screenHeight/2))
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
    
    func createBeaconRegion() -> CLBeaconRegion?{
        return CLBeaconRegion(beaconIdentityConstraint: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor), identifier: beaconID)
    }
    
    /*
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus){
        if status == .authorizedAlways{
            if(CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)){
                if(CLLocationManager.isRangingAvailable()){
                    startScanning()
                }
            }
        }
    }
     */
    
    func startScanning(){
        let beaconRegion = createBeaconRegion()!
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor))
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        let coronaBeacons = beacons.filter{ $0.proximity != CLProximity.unknown}
        if coronaBeacons.count > 0{
            let nearestBeacon = coronaBeacons[0] as CLBeacon
            if(nearestBeacon.proximity == CLProximity.near){
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                do {
                   try AVAudioSession.sharedInstance().setCategory(.playback)
                } catch(let error) {
                    print(error.localizedDescription)
                }
                coughPlayer.play()
            }
        }
    }
    
    func advertiseDevice(region: CLBeaconRegion){
        let peripheralData = region.peripheralData(withMeasuredPower: power)
        
        peripheral.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
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
