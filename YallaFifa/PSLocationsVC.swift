//
//  PSLocationsVC.swift
//  YallaFifa
//
//  Created by Mostafa El_sayed on 6/9/17.
//  Copyright © 2017 TheGang. All rights reserved.
//

import UIKit

class PSLocationsViewController: GlobalController {

    //@IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var psNameTextField: UITextField!
    @IBOutlet weak var psPhoneNumberTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var currentPSLocationAddress = "Address1"
    var psChoosedLocation:Location!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollViewInitilaizer(scrollView: scrollView)
        print("dah l final zfft \(psChoosedLocation.latitude),\(psChoosedLocation.longtude)")
        print(psChoosedLocation.latitude)
    }

    @IBAction func backBtnAct(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func addNewPSLocation(_ sender: Any) {
        self.view.endEditing(true)
        var errorMessageTitle = ""
        var errorMessageContent = ""
        
        if self.psNameTextField.text!.characters.count <= 2 {
            errorMessageTitle = "Invalid Name"
            errorMessageContent = "Please enter name greater than 2 charachters"
            
        }
        if !isValidPhone(testStr: self.psPhoneNumberTextField.text!) || self.psPhoneNumberTextField.text?.characters.count != 11{
            errorMessageTitle = "Invalid phone number"
            errorMessageContent = "Please enter valid phone number"
        }
        
        if errorMessageContent != "" {
            self.displayMessage(title: errorMessageTitle, message: errorMessageContent)
        }else {
            
            let alertController = UIAlertController(title: "Success", message: "Successfuly added new play station, press ok to return back to the map", preferredStyle: .alert)
            
            // Create the actions
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                UIAlertAction in
                RequestManager.defaultManager.newPS(name: self.psNameTextField.text!, phone: self.psPhoneNumberTextField.text!, longtude: self.psChoosedLocation.longtude, latitude: self.psChoosedLocation.latitude)
                self.navigationController?.popViewController(animated: false)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
       
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  textField.tag == 2 {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 11
        } else if  textField.tag == 1 {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 20
        }else {
            return true
        }
        
    }
}

