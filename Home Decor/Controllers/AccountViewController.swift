//
//  AccountViewController.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 18/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    let db = Firestore.firestore()
    var currentUser = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(createGradientLayer())
        imageContainerView.layer.cornerRadius = self.imageContainerView.frame.size.width / 2
        imageContainerView.clipsToBounds = true
        cameraButton.layer.cornerRadius = self.cameraButton.frame.size.width/2
        cameraButton.clipsToBounds = true
        emailLabel.text = UserDefaults.standard.string(forKey: "user")!
        currentUser = emailLabel.text!
        print(currentUser)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    
    func createGradientLayer() -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.containerView.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.colors = [UIColor.yellow.cgColor, UIColor.orange.cgColor]
        return gradientLayer
    }

    @IBAction func cameraButtonAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        //        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
        //            self.getImage(fromSourceType: .camera)
        //        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        profileImageView.isHidden = false
        profileImageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func getData()
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        db.collection("users").getDocuments { (querySnapshot, err) in
            if let err = err{
                print("Error getting documents \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    if self.currentUser == (document.data()["email"] as! String) {
                        let name = (document.data()["name"] as! String)
                        self.nameLabel.text = name
                        let phone = (document.data()["phone"] as! String)
                        self.phoneLabel.text = phone
                    }
                }
            }
            SVProgressHUD.dismiss()
        }
    }
}
//let uploadRef = Storage.storage().reference(withPath: "posts/\(postedID).jpg")
//guard let imageData = uploadedImage.image?.jpegData(compressionQuality: 0.75) else { return }
//let uploadMetadata = StorageMetadata.init()
//uploadMetadata.contentType = "uploads/jpeg"
//uploadRef.putData(imageData, metadata: uploadMetadata) { (uploadedMetadata, error) in
//    if let error = error{
//        print(error.localizedDescription)
//    }
//    else
//    {
//        print(uploadedMetadata!)
//    }
//}
