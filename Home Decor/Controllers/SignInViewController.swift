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
import SVProgressHUD

class SignInViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var fullNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumberTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    
    let actionCodeSettings = ActionCodeSettings()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        fullNameTextField.delegate = self
        phoneNumberTextField.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        actionCodeSettings.url = URL(string: "https://sahebsingh.page.link")
        // The sign-in operation has to always be completed in the app.
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""        
        passwordTextField.text = ""
        fullNameTextField.text = ""
        phoneNumberTextField.text = ""
    }
    
    @IBAction func backToLoginButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        uploadData()
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                let otp = 12345
                UserDefaults.standard.set(otp, forKey: "userOTP")
                SVProgressHUD.dismiss()
                let verifyVC = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                self.navigationController?.pushViewController(verifyVC, animated: true)
                
            }
            if let error = error {
                SVProgressHUD.dismiss()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
//
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//    }
//
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//            UIView.animate(withDuration: 0.0) {
//                self.viewHeight.constant = keyboardHeight + 50
//                self.view.layoutIfNeeded()
//            }
//        }
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        UIView.animate(withDuration: 0.0) {
//            self.viewHeight.constant = 509
//            self.view.layoutIfNeeded()
//
//    }
//    }
    
    func uploadData() {
        var ref : DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            
            "name" : "\(fullNameTextField.text!)",
            "phone" : "\(phoneNumberTextField.text!)",
            "email" : "\(emailTextField.text!)"
            
        ]) { err in
            
            if let err = err{
                print("Error documenting data \(err)")
            }
            else
            {
                
                print("Document added with ID: \(ref!.documentID)")
            }
            
        }
        //Analytics.logEvent("caption_Posted", parameters: ["value":"\(caption!)"])
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
