//
//  signinVC.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit
import OneSignal
class SigninVC: GlobalController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollViewInitilaizer(scrollView: scrollView)
        loadLastEmailLogined()
//        OneSignal.getTags({ tags in
//            print("tags - \(tags!)")
//            //    registeredUsers = tags[]
//        }, onFailure: { error in
//            print("Error getting tags - \(error?.localizedDescription)")
//         //   completionHandler("\(error?.localizedDescription)",false)
//        })
//        OneSignal.postNotification(["contents": ["en": "Test Message"], "include_player_ids": ["4fb57a71-fbce-4cce-ae1f-ca75f51d0805"]])
    }
    func loadLastEmailLogined()  {
        if  let userEmail = defaults.value(forKey: "email") as? String {
            self.emailTextField.text = userEmail
        }
    }
    
    @IBAction func signinTapped(_ sender: Any) {
        self.view.endEditing(true)
        
        RequestManager.defaultManager.signIn(email: emailTextField.text!, password: passwordTextField.text!) {(status, success) in
            if success {
                
                RequestManager.defaultManager.updateUserAvailability(userStatus: .online)
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "matchDetailsNav") as! UINavigationController
                self.navigationController!.present(vc, animated: true, completion: nil)
            }
            else{
                self.navigationController!.presentAlert(title: "Error" , mssg: status)

            }
        }
    }
    
    
}
