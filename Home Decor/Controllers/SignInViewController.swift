//
//  SignInViewController.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 08/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class SignInViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var fullNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    let actionCodeSettings = ActionCodeSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        emailTextField.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        actionCodeSettings.url = URL(string: "https://sahebsingh.page.link")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backToLoginButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                let otp = 12345
                UserDefaults.standard.set(otp, forKey: "userOTP")
                let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                self.navigationController?.pushViewController(verifyVC, animated: true)
            }
            if let error = error {
                let alert = UIAlertController(title: "\(error.localizedDescription)", message: "", preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
        }
        Auth.auth().sendSignInLink(toEmail: emailTextField.text!, actionCodeSettings: actionCodeSettings) { error in
            if let error = error {
                print("\(error.localizedDescription)")
            }
            else{
                let alert = UIAlertController(title: "Check your email to comeplete Sign In", message: "", preferredStyle: .alert )
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        checkEmptyFields()
    }
    
    func checkEmptyFields() {
        
        if emailTextField.text?.count == 0 || passwordTextField.text?.count == 0 || phoneNumberTextField.text?.count == 0 || fullNameTextField.text?.count == 0 {
            
            let alert = UIAlertController(title: "Missing Fields", message: "Please enter the missing Information", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if emailTextField.isEditing {
            if let text = textField.text {
                if let myTextField = textField  as? SkyFloatingLabelTextField{
                    if !text.contains("@"){
                        myTextField.errorMessage = "Invalid Email"
                    }
                    else {
                        myTextField.errorMessage = ""
                    }
                }
            }
        }
        
        else if passwordTextField.isEditing {
            if let text = textField.text {
                if let myTextField = textField  as? SkyFloatingLabelTextField{
                    if text.count < 5 {
                        myTextField.errorMessage = "Invalid Password"
                    }
                    else {
                        myTextField.errorMessage = ""
                    }
                }
            }
        }
        return true
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
