//
//  ProductDescriptionVC.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 09/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
class ProductDescriptionVC: UIViewController {

    let db = Firestore.firestore()
    var descImage : UIImage?
    var descName : String = ""
    var descType : String = ""
    var descPrice : Double = 0.0
    var descColor : String = ""
    var descWeight : String = ""
    var userEmail : String = ""
    
    

    @IBOutlet weak var addToCartBadge: UIView!
    @IBOutlet weak var addToCartLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        addToCartBadge.layer.cornerRadius = addToCartBadge.frame.size.width / 2
        productPriceLabel.text = "Rp \(String(descPrice))"
        productImageView.image = descImage
        productNameLabel.text = descName
        productTypeLabel.text = descType
        addToCartLabel.text = String(UserDefaults.standard.integer(forKey: "Items_in_Cart"))
        colorLabel.text = "\(descColor)"
        weightLabel.text = "\(descWeight) Kg"
        userEmail = UserDefaults.standard.string(forKey: "user")!
        print(userEmail)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        priceView.layer.cornerRadius = priceView.frame.size.height / 2
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addCartButton(_ sender: Any) {
        let items = UserDefaults.standard.integer(forKey: "Items_in_Cart")
        UserDefaults.standard.set(items+1, forKey: "Items_in_Cart")
        addToCartLabel.text = String(UserDefaults.standard.integer(forKey: "Items_in_Cart"))
        var ref : DocumentReference? = nil
        ref = db.collection("cart").addDocument(data: [
            
            "name" : "\(descName)",
            "color" : "\(descColor)",
            "type" : "\(descType)",
            "weight" : "\(descWeight)",
            "price" : descPrice,
            "user" : "\(userEmail)"
            
        ]) { err in
            if let err = err {
                print(err.localizedDescription)
            }
            else{
                print("Document added with ID: \(ref!.documentID)")
            }
        }
//        Analytics.logEvent("caption_Posted", parameters: ["value":"\(caption!)"])
        let uploadRef = Storage.storage().reference(withPath: "cart/\(ref!.documentID).png")
        guard let imageData = productImageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "cart/png"
        uploadRef.putData(imageData, metadata: uploadMetadata) { (uploadedMetadata, error) in
            if let error = error{
                print(error.localizedDescription)
            }
            else
            {
                print(uploadedMetadata!)
            }
        }
        let alert = UIAlertController(title: "Item added to Cart", message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        var time = 3
        while time >= 0 {
            time = time - 1
            if time == 0 {
                dismiss(animated: true, completion: nil)
                break
            }
        }
//        Analytics.logEvent("image_Posted", parameters: ["url" : "uploads/\(postedID).jpg"])
    }
    @IBAction func cartButton(_ sender: Any) {
        
        let cartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
}

//[
//
//
//
//]


