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

class DistanceViewController: UIViewController, CLLocationManagerDelegate, CBPeripheralManagerDelegate {

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
                locationManager.stopRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor))
            case .poweredOn:
                let myRegion = createBeaconRegion()!
                advertiseDevice(regiion: myRegion)
                locationManager.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: major, minor: minor))
            default:
                locationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isAnimating = false
        beaconSwitch.setOn(false, animated: false)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        peripheral = CBPeripheralManager()
        peripheral.delegate = self
        power = NSNumber(integerLiteral: 20)
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        
        uuid = UUID(uuidString: "7959A986-DC83-413A-B22E-EBE8B3606B42")
        major = 100
        minor = 1
    }
    
    @IBAction func closeVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func beaconSwitchFlipped(_ sender: Any) {
        if beaconSwitch.isOn {
            isAnimating = true
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
            locationManager.requestAlwaysAuthorization()
            // on for testing
            //self.appDelegate?.sendNotification()
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
    
    func createBeaconRegion() -> CLBeaconRegion?{
        return CLBeaconRegion(proximityUUID: uuid, major: major, identifier: minor)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:CLAuthorizationStatus){
        if status == .authorizedAlways{
            if(CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self)){
                if(CLLocationManager.isRangingAvailable()){
                    startScanning()
                }
            }
        }
    }
    
    func startScanning(){
        let beaconRegion = createBeaconRegion()
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func locationManger(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion){
        if beacons.count > 0{
            let nearestBeacon = beacons.first!
            while(nearestBeacon.proximity == CLProximity.immediate){
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
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
