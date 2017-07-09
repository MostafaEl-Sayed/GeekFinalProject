//
//  ViewController.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 5/17/17.
//  Copyright © 2017 TheGang. All rights reserved.
//
//
import UIKit

class SignUpVC: GlobalController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollViewInitilaizer(scrollView: scrollView)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    @IBAction func signupTapped(_ sender: Any) {
        
        if !isValidPhone(testStr: phoneNumberTextField.text!) {
            self.presentAlert(title: "Fail to signup" , mssg: "Please enter valid phone number.")
        }else {
            return 
        }
        
        if passwordTextField.text! != confirmPassTextField.text! {
            self.presentAlert(title: "Error" , mssg: "Confirm password field should be the same as password field!")
        }else {
            self.view.endEditing(true)
             RequestManager.defaultManager.sigup(email: emailTextField.text!, password: passwordTextField.text!, phoneNumber: phoneNumberTextField.text!, completionHandler: { (status, success) in
                
                if success {
                    self.navigationController!.popViewController(animated: true)
                }
                else {
                    self.presentAlert(title: "Error" , mssg: status)
                }
                
             })
        }
    }
    
    
}

