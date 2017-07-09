//
//  Globle Controller.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import Foundation
import UIKit

class GlobalController : UIViewController ,UITextFieldDelegate , UIGestureRecognizerDelegate {
    
    private var activeTextField = UITextField()
    private var scrollView :UIScrollView?
    private var  scrollViewHieght:CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        subscribeToKeyboardNotifications()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollViewHieght = scrollView?.contentSize.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func scrollViewInitilaizer(scrollView:UIScrollView){
        self.scrollView = scrollView
    }
    
    
     func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GlobalController.textFieldShouldReturn(_:)))
        view.addGestureRecognizer(tap)
    }
    
    func subscribeToKeyboardNotifications() {
        // Observer to the keyboard to run the keyboardWillShow function when the keyboard is open
        NotificationCenter.default.addObserver(self, selector: #selector(GlobalController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        // Observer to the keyboard to run the keyboardWillHide function when the keyboard is close
        NotificationCenter.default.addObserver(self, selector: #selector(GlobalController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(sender: NSNotification) {
        
        let keyboardHeight = getKeyboardHeight(sender: sender)
        
        // check the keyboard height and move the pop view to the correct postion
        let keyboard_Y_Postion = getTheKeyBoardPostion(keyBoardHeight: keyboardHeight)
        var activeTextFieldFramePostion = activeTextField.frame.origin.y + activeTextField.frame.height
        
        var textFieldSuperView = activeTextField.superview
        while true {
            if let superView = textFieldSuperView {
                activeTextFieldFramePostion += superView.frame.origin.y
                textFieldSuperView = textFieldSuperView?.superview
            }else{
                break
            }
        }
        
        let LeftHandSide = activeTextFieldFramePostion + (activeTextField.frame.height * 2.5)
        if  LeftHandSide > keyboard_Y_Postion {
            let scrollValue =   keyboard_Y_Postion - activeTextFieldFramePostion - (activeTextField.frame.height * 2.5)
            scrollView?.setContentOffset(CGPoint(x: 0, y: -scrollValue), animated: false)
        }
        scrollView?.contentSize.height = keyboardHeight + scrollViewHieght!
    }
    
    func keyboardWillHide(sender: NSNotification){
        scrollView?.contentSize.height = scrollViewHieght!
    }
    
    func getKeyboardHeight(sender: NSNotification) -> CGFloat {
        let deviceInfo = sender.userInfo
        let keyboardSize = deviceInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // func to check the keyboard Y axis postion to help me to move the pop up view to the correct postion
    func getTheKeyBoardPostion(keyBoardHeight : CGFloat) -> CGFloat{
        // get keyboard y axis postion
        let keyBoard_Y_Postion = self.view.frame.height - keyBoardHeight + 15
        return keyBoard_Y_Postion
    }
    
    
    
    //# MARK: - textFields delegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dissmiss the keyboard by return button in the keyboard
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
