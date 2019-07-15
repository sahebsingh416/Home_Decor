//
//  VerifyViewController.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 11/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import OTPTextField
import Fabric

class VerifyViewController: UIViewController {
    
    @IBOutlet weak var otpTextField: OTPTextField!
    
    var otp = String(UserDefaults.standard.integer(forKey: "userOTP"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        // Do any additional setup after loading the view.
    }
    

    @IBAction func verifyAccountButton(_ sender: Any) {
        if otp == otpTextField.text! {
            self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            let alert = UIAlertController(title: "Invalid OTP", message: "Please enter a valid OTP", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
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
