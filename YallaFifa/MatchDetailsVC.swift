//
//  MatchDetailsVC.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MatchDetailsViewContoller: UIViewController, CLLocationManagerDelegate  {

    
    @IBOutlet weak var onlineMatchLabel: UILabel!
    @IBOutlet weak var meetFriendsLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var userCurrentLocation = Location()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(determineMyCurrentLocation())
    }

    
    @IBAction func doneSelectionsBtnAct(_ sender: UIButton) {
        
        if sender.tag == 0 {
            meetFriendsLabel.backgroundColor = UIColor.clear
            onlineMatchLabel.backgroundColor = UIColor(hex: "C6A128", alphaNum: 0.5)
            userType = .online
        }else{
            onlineMatchLabel.backgroundColor = UIColor.clear
            meetFriendsLabel.backgroundColor = UIColor(hex: "C6A128", alphaNum: 0.5)
            userType = .meetFriends
        }
        
    }
    
    func determineMyCurrentLocation() -> Bool{
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            return true
        }else {
            return false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
 
        manager.stopUpdatingLocation()
        let lat = userLocation.coordinate.latitude
        let long = userLocation.coordinate.longitude
        self.userCurrentLocation.longtude = long
        self.userCurrentLocation.latitude = lat
        
    }
    
    
    @IBAction func goButtonTapped(_ sender: Any) {
        RequestManager.defaultManager.updateLocationFor(.user, longtude: self.userCurrentLocation.longtude, latitude: self.userCurrentLocation.latitude)
        if userType == .undefined {
            presentAlert(title: "Fail", mssg: "You should selecet one of this choices")
            return
        }
        currentUser.typeOfUser = "\(userType)"
        if CLLocationManager.locationServicesEnabled() {
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MatchRequestViewController") as! MatchRequestViewController
            vc.userCurrentLocation = self.userCurrentLocation
            RequestManager.defaultManager.updateLocationFor(.user, longtude: userCurrentLocation.longtude, latitude: userCurrentLocation.latitude)
            RequestManager.defaultManager.updateTypeOfUser(typeOfUser:userType)
            self.navigationController!.pushViewController(vc, animated: true)
            
        } else {
            self.displayMessage(title: "Fail access location", message: "Fail to access your location go to setting and access it")
        }
        
    }
    
    @IBAction func signout(_ sender: Any) {
        RequestManager.defaultManager.signout { (status, success) in
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "siginVC")
            self.present(vc, animated: true, completion: nil)
        }
    }
    

}

