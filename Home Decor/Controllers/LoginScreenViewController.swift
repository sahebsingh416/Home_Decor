//
//  LoginScreenViewController.swift
//  
//
//  Created by Saheb Singh Tuteja on 08/07/19.
//

import UIKit
import SkyFloatingLabelTextField
import Firebase
import SVProgressHUD
class LoginScreenViewController: UIViewController,UITextFieldDelegate{

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    let actionCodeSettings = ActionCodeSettings()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        if UserDefaults.standard.bool(forKey: "Logged In"){
            let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            self.navigationController?.pushViewController(tabVC, animated: false)
        }
        emailTextField.delegate = self
        passwordTextField.delegate = self
        self.navigationController?.setNavigationBarHidden(true, animated: false)
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func loginButton(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if user != nil {
                UserDefaults.standard.set(true, forKey: "Logged In")
                UserDefaults.standard.setValue(self.emailTextField.text!, forKey: "user")
                SVProgressHUD.dismiss()
                let tabVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.navigationController?.pushViewController(tabVC, animated: true)
            }
            if let error = error {
                SVProgressHUD.dismiss()
                let alert = UIAlertController(title: "Invalid User", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBAction func signInButton(_ sender: Any) {
        let signVC = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        self.navigationController?.pushViewController(signVC, animated: true)
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
//        else{
//            if let text = textField.text {
//                if let myTextField = textField  as? SkyFloatingLabelTextField{
//                    if text.count < 5{
//                        myTextField.errorMessage = "Invalid Password"
//                    }
//                    else {
//                        myTextField.errorMessage = ""
//                    }
//                }
//            }
//        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func checkEmptyFields() {

        if emailTextField.text?.count == 0 {

            let alert = UIAlertController(title: "Missing Email", message: "Please enter an Email Address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

        }

        if passwordTextField.text?.count == 0 {

            let alert = UIAlertController(title: "Missing Password", message: "Please enter a Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)

        }
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
       
        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassVC") as! ForgotPassVC
        navigationController?.pushViewController(forgotVC, animated: true)
        
    }
    
    
}

