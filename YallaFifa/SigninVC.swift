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
    }
    func loadLastEmailLogined()  {
        if  let userEmail = defaults.value(forKey: "email") as? String {
            self.emailTextField.text = userEmail
        }
    }
    @IBAction func signinTapped(_ sender: Any) {
        self.view.endEditing(true)
        if isInternetAvailable() {
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
        } else {
            displayMessage(title: "Fail access connection", message: "Fail to access your internet connection please check and access it")
        }
    }
 }
