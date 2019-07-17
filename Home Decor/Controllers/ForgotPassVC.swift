//
//  ForgotPassVC.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 17/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//
import UIKit
import Firebase
import SkyFloatingLabelTextField
import SVProgressHUD

class ForgotPassVC: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var emailTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetPasswordButton(_ sender: Any) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
            if let error = error {
                let alert = UIAlertController(title: "Oops", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            SVProgressHUD.dismiss()
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
