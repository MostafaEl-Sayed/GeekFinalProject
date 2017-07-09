//
//  MakeDonationViewController.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 1/29/17.
//  Copyright © 2017 Industrial. All rights reserved.mm
//

import UIKit
import CoreLocation
import Foundation
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MatchRequestViewController: UIViewController , CLLocationManagerDelegate , GMSMapViewDelegate   {

    
    var userCurrentLocation = Location()
    var psChoosedLocationPoint = Location()
    var choosedMetpoint = Location()
    var locationManager = CLLocationManager()
    var userDisplayWhileRequesting = User()
    var meetingPointLocation = Location()
    var filteredUserAvailableNow = [User]()
    var usersData : [User]!
    var psData : [PlayStation]!
    var currentUserDetails:User!
    var targetUserDetails:User!
    var blueLine:BlueLine!
    var prevMarkerPosition:CLLocationCoordinate2D!
    var locatonlabelValue = "Where should we pick up the donation ?"
    var totalDuration: String!
    var totalDistance: String!
    var anotherLocation = false
    var makeBackEnable = false
    var currentStatusOfMakingRequest = false
    var newPSStatusActive = false
    var startChooseMeetingPointStatus = false
    var statusOfSwitchedControllers = false
    var btnPressedStatus = true
    var oneRootadded = false
    var userStatus = true
    var myProfileStatus = false
    var notificationAcceptStatus = false
    var accpetedRequest = false
    var mapCounterStatusOpening = 0
    var counterChangeStatusOflocation = 0
    var totalDistanceInMeters:UInt = 0
    var totalDurationInSeconds:UInt = 0
    
    
    
    
    
    @IBOutlet weak var chooseMeetingPointLabel: UILabel!
    @IBOutlet weak var locationLogoImg: UIImageView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var getCurrentLocationBtn: UIButton!
    @IBOutlet weak var chooseLocationView: UIView!
    @IBOutlet weak var estimationTimeAndDistanceView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var cancelRequestBtn: UIButton!
    @IBOutlet weak var searchViewBtn: UIButton!
    @IBOutlet weak var smallSearchBtn: UIButton!
    @IBOutlet weak var addNewPsView: UIView!
    @IBOutlet weak var chooseMeetingPointLocationView: UIView!
    @IBOutlet weak var endMatchBtn: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var flipViewControllerBtn: UIButton!
    @IBOutlet weak var fliveViewControllerView: UIView!
    @IBOutlet weak var notificationAcceptenceView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupMap()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        resetAllViewsToDefaultValues()
        checkNotificationStatus()
        setupLocation()
    }
    
    func setupMap() {
        self.mapView.delegate = self
        //self.mapView.setMinZoom(10, maxZoom: 19)
        self.mapView.isMyLocationEnabled = true
        self.mapView.isIndoorEnabled = true
    }
    func setupLocation(){
        var latitude  = self.userCurrentLocation.latitude
        var longitude = self.userCurrentLocation.longtude
        
        if latitude == 0 {
            latitude = currentUser.location.latitude
            longitude = currentUser.location.longtude
        }
        let camera = GMSCameraPosition.camera(withLatitude:latitude!,longitude: longitude!, zoom: 14)
        self.mapView.camera = camera
        self.locationLabel.text! = "\(self.locatonlabelValue)"
    }
    func checkNotificationStatus(){
        if !notificationAcceptStatus {
            loadData()
        }else {
            
            flipViewControllerBtn.isHidden = true
            fliveViewControllerView.isHidden = true
            addNewPsView.isHidden = true
            chooseLocationView.isHidden = true
            
            drowUserLocationsMarkers(users: [currentUser], imageMarkerName: "user")
            drowUserLocationsMarkers(users: [userDisplayWhileRequesting], imageMarkerName: "user")
            let meetingPoint = User()
            meetingPoint.location.longtude = self.meetingPointLocation.longtude
            meetingPoint.location.latitude = self.meetingPointLocation.latitude
            meetingPoint.typeOfUser = "meetFriends"
            drowUserLocationsMarkers(users: [meetingPoint], imageMarkerName: "finish1")
            createBlueLineBetween2locations(orderedLatLong: "\(userDisplayWhileRequesting.location.latitude!),\(userDisplayWhileRequesting.location.longtude!)",
                endPoints: "\(meetingPoint.location.latitude!),\(meetingPoint.location.longtude!)",rootColor: UIColor.blue)
            createBlueLineBetween2locations(orderedLatLong: "\(currentUser.location.latitude!),\(currentUser.location.longtude!)", endPoints: "\(meetingPoint.location.latitude!),\(meetingPoint.location.longtude!)",rootColor: UIColor.green)
            
            
            cancelRequestBtn.isHidden = true
            
            if !accpetedRequest {
                notificationAcceptenceView.isHidden = false
                
            } else {
                self.callBtn.isHidden = false
                self.endMatchBtn.isHidden = false
            }
            
        }
    }
    func loadData()  {
        userDataObserver()
        if userType == .online {
            self.addNewPsView.isHidden = true
            
        }
        if userType == .meetFriends {
            self.addNewPsView.isHidden = false
            
            playStationDataObserver()
        }
    }
    func resetAllViewsToDefaultValues()  {
        if self.myProfileStatus {
        let defaultValue = CGAffineTransform(translationX: 0, y:0)
        self.menuView.transform = defaultValue
        self.fliveViewControllerView.transform = defaultValue
        self.chooseLocationView.transform = defaultValue
        self.addNewPsView.transform = defaultValue
        self.getCurrentLocationBtn.transform = defaultValue
        self.estimationTimeAndDistanceView.transform = defaultValue
        

        chooseMeetingPointLabel.text! = "Choose Meeting Point"
        self.newPSStatusActive = false
        self.statusOfSwitchedControllers = false
        self.fliveViewControllerView.isHidden = false
        self.flipViewControllerBtn.isHidden = false
        self.myProfileStatus = false
        }
        
    }
    
    func getUserData(compilitionHandler : @escaping ()-> Void){
        RequestManager.defaultManager.getListOfUserData { (data) in
            self.usersData = data
            compilitionHandler()
        }
    }
    func getPlayStationData(compilitionHandler : @escaping ()-> Void){
        RequestManager.defaultManager.getListOfPlayStationData(completionHandler: { (data) in
            self.psData = data
            compilitionHandler()
        })
    }
    func getUserFromLocation(selectedMarker: GMSMarker) -> User {
        let lat = selectedMarker.position.latitude
        let long = selectedMarker.position.longitude
        for user in usersData {
            if user.location.latitude == lat && user.location.longtude == long {
                return user
            }
        }
        return User()
    }
    
    func playStationDataObserver(){
        getPlayStationData {
            self.drowPSLocationsMarkers(playstationLocations: self.psData, imageMarkerName: "onlineMatch")
        }
    }
    func userDataObserver(){
        getUserData {
            self.drowUserLocationsMarkers(users: self.usersData, imageMarkerName: "user")
        }
        
    }
    
    func createBlueLineBetween2locations(orderedLatLong startPoint :String,endPoints:String,rootColor:UIColor){
        
        let orgin = startPoint
        let destination = endPoints
        
        RequestManager.defaultManager.getDirections(origin: orgin, destination: destination, completionHandler: { (status, success , data) -> Void in
            if success {
                self.blueLine = data
                self.drawRoute(rootColor:rootColor)
                self.calculateTotalDistanceAndDuration()
                
            }
            else {
                
                self.displayMessage(title: "Request Field", message: "Canot calculate distence betweeen 2 locations")
                
            }
        })
        
    }
    func drawRoute(rootColor:UIColor) {
        self.estimationTimeAndDistanceView.isHidden = false
        let route = blueLine.overviewPolyline["points"] as! String
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        blueLine.routePolyline = GMSPolyline(path: path)
        if notificationAcceptStatus {
            blueLine.routePolyline.strokeColor = rootColor
        }
        blueLine.routePolyline.strokeWidth = 2
        blueLine.routePolyline.map = self.mapView
        oneRootadded = true
        
        
    }
    func calculateTotalDistanceAndDuration() {
        
        let legs:[NSDictionary] = self.blueLine.selectedRoute.getValueForKey(Key: "legs", callBack: [])
        totalDistanceInMeters = 0
        totalDurationInSeconds = 0
        
        for leg in legs {
            totalDistanceInMeters += (leg["distance"] as! NSDictionary)["value"] as! UInt
            totalDurationInSeconds += (leg["duration"] as! NSDictionary)["value"] as! UInt
        }
        
        let distanceInKilometers: Double = Double(totalDistanceInMeters / 1000)
        totalDistance = "Total Distance: \(distanceInKilometers) Km"
        self.distanceLabel.text! = "\(distanceInKilometers) Km"
        
        let mins = totalDurationInSeconds / 60
        let hours = mins / 60
        let days = hours / 24
        let remainingHours = hours % 24
        let remainingMins = mins % 60
        let remainingSecs = totalDurationInSeconds % 60
        
        totalDuration = "Duration: \(days) d, \(remainingHours) h, \(remainingMins) mins, \(remainingSecs) secs"
        self.timeLabel.text! = "\(remainingMins) mins"
       
        let translationValue = estimationTimeAndDistanceView.frame.size.width - menuView.frame.size.width
        let left = CGAffineTransform(translationX:-translationValue ,y: 0)
        let top = CGAffineTransform(translationX: 0, y: -addNewPsView.frame.size.height + 8)
        self.fliveViewControllerView.isHidden = true
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.estimationTimeAndDistanceView.transform = left
            self.cancelRequestBtn.transform = top
        }, completion: nil)
        
        
        
    }
    
    func startAnimatingViews() {
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let translationValue = -chooseLocationView.frame.size.width + menuView.frame.size.width - (0.1*screenWidth/2)
        
        
        let left = CGAffineTransform(translationX:translationValue ,y: 0)
        let top = CGAffineTransform(translationX: 0, y: -addNewPsView.frame.size.height + 8)
        let down = CGAffineTransform(translationX: 0, y: addNewPsView.frame.size.height)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            
            self.addNewPsView.transform = down
            self.chooseLocationView.transform = left
            self.flipViewControllerBtn.transform = top
            
        }, completion: nil)
        //chooseRandomlyBtn.isEnabled = false
        
        //choosePointToMeetFriendLabel.isHidden = false
        //self.chooseRandomlyBtn.setTitle("Confirm Request", for: .normal)
        self.smallSearchBtn.setImage(UIImage(named:"RightLongArrow"), for: .normal)
        makeBackEnable = true
        searchViewBtn.isEnabled = false
        flipViewControllerBtn.isHidden = true
        
    }
    func drowUserLocationsMarkers(users:[User]?,imageMarkerName:String)  {
        // clear all old markers from the map
        mapView.clear()
        guard users != nil else {
            return
        }
        filteredUserAvailableNow = []
        for user in users! {
            
            if "\(user.typeOfUser)" != "\(userType)" || (user.email == currentUser.email && !notificationAcceptStatus) || user.userAvailability == "offline" {
                
                continue
            }
            
            self.filteredUserAvailableNow.append(user)
            let lat = user.location.latitude
            let long = user.location.longtude
            let position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let marker = GMSMarker(position: position)
            marker.title = "\(userType)"
            marker.icon = UIImage(named: imageMarkerName)
            marker.map = mapView
            
        }
    }
    func drowPSLocationsMarkers(playstationLocations:[PlayStation]?,imageMarkerName:String)  {
        // clear all old markers from the map
        //mapView.clear()
        guard playstationLocations != nil else {
            return
        }
        if userType == .online {
            return
        }
        
        for psLocation in playstationLocations! {
            let lat = psLocation.location.latitude
            let long = psLocation.location.longtude
            let position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            let marker = GMSMarker(position: position)
            marker.title = "\(userType)"
            marker.icon = UIImage(named: imageMarkerName)
            
            marker.map = mapView
            
        }}
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.stopUpdatingLocation()
        let camera = GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!,longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 14)
        self.mapView.camera = camera
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if isInternetAvailable() {
            if !notificationAcceptStatus {
                if marker.icon == UIImage(named:"user") {
                    self.targetUserDetails = getUserFromLocation(selectedMarker: marker)
                    
                    chooseMeetingPointLabel.text! = "Choose Meeting Point"
                    newPSStatusActive = false
                    self.chooseMeetingPointLocationView.isHidden = false
                    self.locationLogoImg.isHidden = false
                    if userType == .online {
                        self.locationLogoImg.isHidden = true
                        chooseMeetingPointLabel.text! = "Show Player Profile"
                        self.mapView.isUserInteractionEnabled = false
                        chooseMeetingPointLocationView.isHidden = false
                        let top = CGAffineTransform(translationX: 0, y: -addNewPsView.frame.size.height + 8)
                        UIView.animate(withDuration: 0.3, animations: {
                            self.cancelRequestBtn.transform = top
                        })
                        return true
                    }
                }
                addNewPsView.isHidden = true
                currentStatusOfMakingRequest = true
                startAnimatingViews()
                
                
                if oneRootadded && prevMarkerPosition.latitude == marker.position.latitude && prevMarkerPosition.longitude == marker.position.longitude{
                    return false
                }
                if oneRootadded {
                    blueLine.routePolyline.map = nil
                }
                
                createBlueLineBetween2locations(orderedLatLong: "\(userCurrentLocation.latitude!),\(userCurrentLocation.longtude!)", endPoints: "\(marker.position.latitude),\(marker.position.longitude)",rootColor: UIColor.blue)
                prevMarkerPosition = marker.position
                return true
            }else{
                return false
            }
        }else {
           displayMessage(title: "Fail access connection", message: "Fail to access your internet connection please check and try again")
        }
        return false
    }
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        if currentStatusOfMakingRequest || newPSStatusActive {
            let lat = position.target.latitude
            let long = position.target.longitude
            if !newPSStatusActive {
                choosedMetpoint.latitude = lat
                choosedMetpoint.longtude = long
                
            }else {
                
                psChoosedLocationPoint.latitude = lat
                psChoosedLocationPoint.longtude = long
                
            }
            
            let defaultValue = CGAffineTransform(translationX: 0, y:0)
            let translationValue = estimationTimeAndDistanceView.frame.size.width - menuView.frame.size.width
            let left = CGAffineTransform(translationX:-translationValue ,y: 0)
            let top = CGAffineTransform(translationX: 0, y: -addNewPsView.frame.size.height + 8)
            UIView.animate(withDuration: 0.3, animations: {
                
                
                self.addNewPsView.transform = defaultValue
                self.estimationTimeAndDistanceView.transform = left
                self.getCurrentLocationBtn.transform = defaultValue
                self.menuView.transform = defaultValue
                self.fliveViewControllerView.transform = defaultValue
                self.cancelRequestBtn.transform = top
                self.addNewPsView.transform = defaultValue
            })
            self.chooseLocationView.isHidden = false
        }
        
    }
    func mapViewDidStartTileRendering(_ mapView: GMSMapView) {
        
        self.mapCounterStatusOpening += 1
        if (statusOfSwitchedControllers && self.mapCounterStatusOpening > 2 && self.btnPressedStatus && currentStatusOfMakingRequest) || (newPSStatusActive && statusOfSwitchedControllers && self.mapCounterStatusOpening > 2 && self.btnPressedStatus ){
            
            let down = CGAffineTransform(translationX: 0, y: addNewPsView.frame.size.height + getCurrentLocationBtn.frame.size.height)
            let top = CGAffineTransform(translationX: 0, y: -100)
            let right = CGAffineTransform(translationX: 80, y: 0)
            UIView.animate(withDuration: 0.01, animations: {
                
                self.chooseLocationView.alpha = 1.0
                self.estimationTimeAndDistanceView.transform = right
                self.cancelRequestBtn.transform = down
                self.menuView.transform = top
                self.fliveViewControllerView.transform = top
                self.addNewPsView.transform = down
            })
            self.chooseLocationView.isHidden = true
        }
        statusOfSwitchedControllers = true
        
    }
    
    
    
    @IBAction func chooseRandomlyBtnAct(_ sender: Any) {
//        self.chooseMeetingPointLocationView.isHidden = true
//        self.locationLogoImg.isHidden = true
        if newPSStatusActive {
            self.performSegue(withIdentifier: "PSLocationsViewController", sender: nil)
        }else {
            self.performSegue(withIdentifier: "UserProfileViewController", sender: nil)
        }
        
    }
    @IBAction func callBtnAct(_ sender: Any) {
        guard let number = URL(string: "tel://" + self.userDisplayWhileRequesting.phone) else { return }
        UIApplication.shared.open(number)

    }
    @IBAction func flipViewControllerBtnAct (_ sender: Any) {
        let  mainStory = UIStoryboard(name: "Main", bundle: nil)
        let search = mainStory.instantiateViewController(withIdentifier: "MatchRequestTableViewController") as! MatchRequestTableViewController
        search.nearbyUsers = self.filteredUserAvailableNow
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(1.0)
        self.navigationController!.pushViewController(search, animated: false)
        UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
        UIView.commitAnimations()
    }
    @IBAction func chooseAnotherLocationBtnAct(_ sender: Any) {
        self.counterChangeStatusOflocation = 0 
        let autocompletecontroller = GMSAutocompleteViewController()
        autocompletecontroller.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment  //suitable filter type
        filter.country = "EG"  //appropriate country code
        autocompletecontroller.autocompleteFilter = filter
        self.present(autocompletecontroller, animated: true, completion: nil)
    }
    @IBAction func currentLocation(_ sender: Any) {
        anotherLocation = false
        self.btnPressedStatus = false
        let latitude  = self.locationManager.location?.coordinate.latitude
        let longitude = self.locationManager.location?.coordinate.longitude
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                
                displayMessage(title: "Could not find your location", message: "Please allow YallaFifa to access your location from settings")
            case .authorizedAlways, .authorizedWhenInUse:
                let camera = GMSCameraPosition.camera(withLatitude: latitude!,longitude: longitude!, zoom: self.mapView.camera.zoom)
                
                UIView.animate(withDuration: 20.0, animations: {
                    self.mapView.camera = camera
                })
            }
        } else {
            
            
            displayMessage(title: "Could not find your location", message: "Please allow YallaFifa to access your location from settings")
        }
        self.btnPressedStatus = true
        
    }
    @IBAction func returnBackSearchBtnAct(_ sender: Any) {
        if makeBackEnable {
            searchViewBtn.isEnabled = true
            let defaultValue = CGAffineTransform(translationX:0 ,y: 0)
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
                self.chooseLocationView.transform = defaultValue
                
                self.smallSearchBtn.setImage(UIImage(named:"Search"), for: .normal)
            }, completion: nil)
            makeBackEnable = false

        }
    }
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func acceptUserRequestBtnAct(_ sender: Any) {
        
        RequestManager.defaultManager.sendRequestToUser(currentUser,notificationMessage: "Let`s go , I have\(self.totalDurationInSeconds/60) Mins to reach",notificationStatus: "accept", meetingPoint: self.meetingPointLocation) { (_, _) in
        }
        self.notificationAcceptenceView.isHidden = true
        self.endMatchBtn.isHidden = false
        self.callBtn.isHidden = false
        
        
    }
    @IBAction func cancelUserRequestBtnAct(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
        RequestManager.defaultManager.loadCurrentUser()
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func cancelRequestBtnAct(_ sender: Any) {
        
        if notificationAcceptStatus {
            notificationAcceptStatus = false
            flipViewControllerBtn.isHidden = false
            fliveViewControllerView.isHidden = false
            addNewPsView.isHidden = false
            chooseLocationView.isHidden = false
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
            self.navigationController!.present(vc, animated: true, completion: nil)
        }
        
        self.smallSearchBtn.setImage(UIImage(named:"Search"), for: .normal)
        makeBackEnable = true
        searchViewBtn.isEnabled = true
        if oneRootadded {
            self.blueLine.routePolyline.map = nil
        }
        oneRootadded = false
        newPSStatusActive = false
        self.locationLogoImg.isHidden = true
        self.currentStatusOfMakingRequest = false
        
        
        
        let defaultValue = CGAffineTransform(translationX:0 ,y: 0)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.addNewPsView.transform = defaultValue
            self.cancelRequestBtn.transform = defaultValue
            self.chooseLocationView.transform = defaultValue
            
            self.estimationTimeAndDistanceView.transform = defaultValue
            self.flipViewControllerBtn.transform = defaultValue
        }, completion: { (finished: Bool) in
            self.fliveViewControllerView.isHidden = false
            self.chooseMeetingPointLocationView.isHidden = true
            self.estimationTimeAndDistanceView.isHidden = true
            self.mapView.isUserInteractionEnabled = true
            if userType == .meetFriends {
                self.addNewPsView.isHidden = false
            }
        })
        
        
        }
    @IBAction func searchViewBtnAct(_ sender: Any) {
        self.counterChangeStatusOflocation = 0
        let autocompletecontroller = GMSAutocompleteViewController()
        autocompletecontroller.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment  //suitable filter type
        filter.country = "EG"  //appropriate country code
        autocompletecontroller.autocompleteFilter = filter
        self.present(autocompletecontroller, animated: true, completion: nil)
        
    }
    @IBAction func addNewPSLocationBtnAct(_ sender: Any) {
        addNewPsView.isHidden = true
        let top = CGAffineTransform(translationX: 0, y: -addNewPsView.frame.size.height + 8)
        self.fliveViewControllerView.isHidden = true
        UIView.animate(withDuration: 0.4, delay: 0.0, options: [], animations: {
            self.cancelRequestBtn.transform = top
        }, completion: nil)
        
        chooseMeetingPointLabel.text! = "Choose Play Station Point"
        self.chooseMeetingPointLocationView.isHidden = false
        self.locationLogoImg.isHidden = false
        
        newPSStatusActive = true
    }
    @IBAction func menuBtnAct(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        
        // Create the actions
        let signoutAction = UIAlertAction(title: "Signout", style: UIAlertActionStyle.default) {
            UIAlertAction in
            RequestManager.defaultManager.signout(completionHandler: { (status, success) in
                if success {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "siginVC") as! UINavigationController
                    self.navigationController!.present(vc, animated: true, completion: nil)
                    
                }else {
                    self.presentAlert(title: "Fail", mssg: status)
                }
            })
            self.view.endEditing(true)
        }
        
        let userProfileAction = UIAlertAction(title: "Profile", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.myProfileStatus = true
            self.performSegue(withIdentifier: "UserProfileViewController", sender: nil)
        }
        let changeMatchTypeAction = UIAlertAction(title: "Change Match Type", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        
        var userStatusTitle = "Offline"
        if userStatus == true {
            userStatusTitle = "Online"
        }
        let userStatusAction = UIAlertAction(title: userStatusTitle , style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.userStatus = !self.userStatus
            if self.userStatus{
                RequestManager.defaultManager.updateUserAvailability(userStatus: .online)
            }else {
                RequestManager.defaultManager.updateUserAvailability(userStatus: .offline)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(changeMatchTypeAction)
        alertController.addAction(userStatusAction)
        alertController.addAction(userProfileAction)
        alertController.addAction(cancelAction)
        alertController.addAction(signoutAction)
        self.present(alertController, animated: true, completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PSLocationsViewController"{
            let psLocationVC = segue.destination as! PSLocationsViewController
            if  self.psChoosedLocationPoint.longtude == 0.0 {
                self.psChoosedLocationPoint.longtude = self.mapView.camera.target.longitude
                self.psChoosedLocationPoint.latitude = self.mapView.camera.target.latitude
                
            }
            psLocationVC.psChoosedLocation = self.psChoosedLocationPoint
            
            
        } else if segue.identifier == "UserProfileViewController" {
            let userProfileVC = segue.destination as! UserProfileViewController
            
            
            if myProfileStatus {
                userProfileVC.startRequesting = false
                userProfileVC.userProfileData = currentUser
            }else{
                userProfileVC.startRequesting = true
                userProfileVC.choosedMetpoint = self.choosedMetpoint
                userProfileVC.userProfileData = targetUserDetails
            }
            
        }
    }
    
}

extension MatchRequestViewController:   UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognixzer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
extension MatchRequestViewController:  GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        self.locatonlabelValue = place.name
        self.anotherLocation = true
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // To handle error
        print(error)
        
    }
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
}
