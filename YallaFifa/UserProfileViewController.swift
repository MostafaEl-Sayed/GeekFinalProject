//
//  UserProfileViewController.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/20/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    @IBOutlet weak var callImgLogo: UIImageView!
    
    @IBOutlet weak var smallLine: UIView!
    @IBOutlet weak var callImgBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var requestGameBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var notificationResponseView: UIView!
    @IBOutlet weak var makeNewRequestBtn: UIButton!
    
    var fifaAccountIDTextField: UITextField!
    var choosedMetpoint = Location()
    var userProfileData = User()
    var notificationTitle = ""
    var startRequesting = false
    var notificationComeProfileStatus = false
    var startNotificationBtn = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareDataOfProfileView()
        setupViewWhileNotification()
    }
    func setupViewWhileNotification()  {
        if notificationComeProfileStatus {
            if  notificationTitle != "" {
                
                let idArr = notificationTitle.characters.split{$0 == ":"}.map(String.init)
                let userFifaID: String = idArr[1]
                self.requestGameBtn.isHidden = false
                self.requestGameBtn.isEnabled = false
                self.requestGameBtn.setTitle("Fifa Id : \(userFifaID)", for: .normal)
                self.requestGameBtn.setTitleColor(UIColor.green, for: .normal)
                self.makeNewRequestBtn.isHidden = false
                self.backBtn.isHidden = true
            }else {
                prepareStatusOfNotificationView()
            }
        }
    }
    func prepareStatusOfNotificationView(){
        self.requestGameBtn.isHidden = true
        self.notificationResponseView.isHidden = false
        self.backBtn.isHidden = true
        
    
    }
    func prepareDataOfProfileView(){
        if startRequesting {
            self.requestGameBtn.isHidden = false
        }else {
            callImgBtn.isHidden = true
            callImgLogo.isHidden = true
            smallLine.isHidden = true
        }
        userNameLabel.text! = userProfileData.email
        userPhoneNumber.text! = userProfileData.phone
    }
    func configurationTextField(textField: UITextField!){
        textField.placeholder = "..."
        self.fifaAccountIDTextField = textField
    }
    
    @IBAction func makeNewRequestBtnAct(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
        RequestManager.defaultManager.loadCurrentUser()
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
    }

    @IBAction func callBtnAct(_ sender: Any) {
        guard let number = URL(string: "tel://" + self.userProfileData.phone) else { return }
        UIApplication.shared.open(number)
    }
    @IBAction func startRequestingBtnAct(_ sender: Any) {
        startNotificationBtn = true
        if isInternetAvailable() {
            if !startNotificationBtn {
                RequestManager.defaultManager.sendRequestToUser(userProfileData,notificationMessage: "Yalla Bena nl3boo ya zmerro",notificationStatus: "newRequest",meetingPoint: choosedMetpoint) { (_, _) in
                }
            }else {
                displayMessage(title: "Fail access connection", message: "Fail to access your internet connection please check and access it")
                }
                self.startNotificationBtn = false
            }
           
        
    }
    @IBAction func acceptNotificationVtnAct(_ sender: Any) {
        
        let alert = UIAlertController(title: "Fifa ID", message: "Please Enter Your Fifa ID .", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            RequestManager.defaultManager.sendRequestToUser(currentUser,notificationMessage: "Yalla , FifaID:\(self.fifaAccountIDTextField.text!)",notificationStatus: "accept", meetingPoint: Location()) { (_, _) in
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true,completion: nil)
    }
    @IBAction func cancelNotificationBtnAct(_ sender: Any) {
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = storyboard.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
        RequestManager.defaultManager.loadCurrentUser()
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
    }
    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
