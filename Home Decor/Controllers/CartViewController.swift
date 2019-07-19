//
//  CartViewController.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 18/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var itemArray = [Items]()
    let db = Firestore.firestore()
    let currentUser = UserDefaults.standard.string(forKey: "user")!
    @IBOutlet weak var cartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.productImageView.image = itemArray[indexPath.row].sofaImage
        cell.productNameLabel.text = itemArray[indexPath.row].sofaName
        cell.productTypeLabel.text = itemArray[indexPath.row].sofaType
        cell.productPriceLabel.text = "Rp \(itemArray[indexPath.row].sofaPrice)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            deleteData(of: itemArray[indexPath.row].currentID)
            var items = UserDefaults.standard.integer(forKey: "cartItems")
            items -= 1
            UserDefaults.standard.set(items, forKey: "cartItems")
            itemArray.remove(at: indexPath.row)
            tableView.reloadData()
            if itemArray.count == 0 {
                cartTableView.isHidden = true
            }
        }
    }
    
    func getData()
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        db.collection("cart").getDocuments { (querySnapshot, err) in
            self.itemArray.removeAll()
            if let err = err{
                print("Error getting documents \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    let newItem = Items()
                    if self.currentUser == (document.data()["user"] as! String) {
                        let name = (document.data()["name"] as! String)
                        newItem.sofaName = name
                        let price = (document.data()["price"] as! Double)
                        newItem.sofaPrice = price
                        let type = (document.data()["type"] as! String)
                        newItem.sofaType = type
                        let id = "\(document.documentID)"
                        newItem.currentID = id
                        self.cartTableView.reloadData()
                        let storageRef = Storage.storage().reference(withPath: "cart/\(document.documentID).png")
                        storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                            if let error = error{
                                print("Error: \(error)")
                            }
                            if let data = data{
                                newItem.sofaImage = UIImage(data: data)
                                self.cartTableView.reloadData()
                            }
                        }
                        self.itemArray.append(newItem)
                    }
                }
                print(self.itemArray.count)
                if self.itemArray.count == 0 {
                    self.cartTableView.isHidden = true
                }else {
                    self.cartTableView.isHidden = false
                }
                self.cartTableView.reloadData()
            }
            SVProgressHUD.dismiss()
        }
        cartTableView.reloadData()
        
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func deleteData(of id: String) {
        db.collection("cart").document(id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    @IBAction func clearCartButton(_ sender: Any) {
        for product in itemArray {
            deleteData(of: product.currentID)
        }
        itemArray.removeAll()
        cartTableView.reloadData()
        cartTableView.isHidden = true
        UserDefaults.standard.set(0, forKey: "cartItems")
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
