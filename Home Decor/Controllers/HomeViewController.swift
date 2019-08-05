//
//  HomeViewController.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 08/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Firebase
import BottomDrawer
import SVProgressHUD

class HomeViewController: UIViewController,UISearchBarDelegate{

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var furnitureCollection: UICollectionView!
    @IBOutlet weak var searchedCollecton: UICollectionView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var productsLabel: UILabel!
    @IBOutlet weak var addToCartLabel: UILabel!
    @IBOutlet weak var addToCartBadge: UIView!
    
    var filteredSearch = [String]()
    var filteredPrice = [String : Double]()
    var itemArray = [Items]()
    let db = Firestore.firestore()
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets(top: 10.0,
                                     left: 15.0,
                                     bottom: 10.0,
                                     right: 15.0)
    
    //MARK: - viewDidLoad() Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.setValue(Auth.auth().currentUser?.email!, forKey: "user")
        UserDefaults.standard.set([], forKey: "dataToFilter")
        UserDefaults.standard.set([:], forKey: "filteredPrice")
        //print(String(UserDefaults.standard.integer(forKey: "cartItems")))
        Fabric.sharedSDK().debug = true
        secondView.isHidden = true
        furnitureCollection.delegate = self
        furnitureCollection.dataSource = self
        searchedCollecton.delegate = self
        searchedCollecton.dataSource = self
        searchBar.layer.borderWidth = 10
        addToCartBadge.layer.cornerRadius = addToCartBadge.frame.size.width / 2
        searchBar.layer.borderColor = UIColor(red: 235, green: 235, blue: 235, alpha: 0).cgColor
        getData()
        getItemsInCart()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        filteredPrice = UserDefaults.standard.dictionary(forKey: "filteredPrice") as! [String : Double]
        filteredSearch = UserDefaults.standard.array(forKey: "dataToFilter") as! [String]
        print(filteredSearch.count)
        print(filteredPrice.count)
        print("Hey")
        if filteredSearch.count == 0 && filteredPrice.count == 0{
            print("Hello")
        }
        else{
           searchFilteredData(for: filteredSearch, price: filteredPrice)
            searchedCollecton.reloadData()
        }
        addToCartLabel.text = String(UserDefaults.standard.integer(forKey: "cartItems"))
        getData()
        furnitureCollection.reloadData()
    }
    
    // MARK: - Get whole data from Firebase
    
    func getData()
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        db.collection("products").getDocuments { (querySnapshot, err) in
            self.itemArray.removeAll()
            if let err = err{
                print("Error getting documents \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    let newItem = Items()
                    
                    let name = (document.data()["name"] as! String)
                    newItem.sofaName = name
                    let price = (document.data()["price"] as! Double)
                    newItem.sofaPrice = price
                    let type = (document.data()["type"] as! String)
                    newItem.sofaType = type
                    let color = (document.data()["color"] as! String)
                    newItem.sofaColor = color
                    let weight = (document.data()["weight"] as! String)
                    newItem.sofaWeight = weight
                    self.furnitureCollection.reloadData()
                    let storageRef = Storage.storage().reference(withPath: "products/\(document.documentID).png")
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                        if let error = error{
                            print("Error: \(error)")
                        }
                        if let data = data{
                            newItem.sofaImage = UIImage(data: data)
                            self.furnitureCollection.reloadData()
                        }
                    }
                    self.itemArray.append(newItem)
                }
                self.furnitureCollection.reloadData()
                SVProgressHUD.dismiss()
            }
            
        }
        furnitureCollection.reloadData()
        UserDefaults.standard.setValue(Auth.auth().currentUser?.email!, forKey: "user")
        getItemsInCart()

    }
    
    func getItemsInCart()
    {
        var itemsInCart = 0
        let user = UserDefaults.standard.string(forKey: "user")
        print(user)
        db.collection("cart").getDocuments { (querySnapshot, err) in
            if let err = err{
                print("Error getting documents \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    if user == (document.data()["user"] as! String){
                        itemsInCart += 1
                    }
                    UserDefaults.standard.set(itemsInCart, forKey: "cartItems")
                }
                self.addToCartLabel.text = String(UserDefaults.standard.integer(forKey: "cartItems"))
            }
        }
    }

    
    //MARK: - Search Bar Delegates
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchedData(for: searchBar.text!)
        furnitureCollection.reloadData()
        searchedCollecton.reloadData()
        secondView.isHidden = false
        furnitureCollection.isHidden = true
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getData()
            furnitureCollection.reloadData()
            secondView.isHidden = true
            self.furnitureCollection.isHidden = false
            furnitureCollection.isHidden = false
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    //MARK: - Fetching Data from Firebase for Search
    
    func searchedData(for text : String)
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        db.collection("products").getDocuments { (querySnapshot, err) in
            self.itemArray.removeAll()
            if let err = err{
                print("Error getting documents \(err)")
            }
            else{
                for document in querySnapshot!.documents{
                    let newItem = Items()
                    let name = (document.data()["name"] as! String)
                    newItem.sofaName = name
                    let price = (document.data()["price"] as! Double)
                    newItem.sofaPrice = price
                    let type = (document.data()["type"] as! String)
                    newItem.sofaType = type
                    let color = (document.data()["color"] as! String)
                    newItem.sofaColor = color
                    let weight = (document.data()["weight"] as! String)
                    newItem.sofaWeight = weight
                    self.furnitureCollection.reloadData()
                    let storageRef = Storage.storage().reference(withPath: "products/\(document.documentID).png")
                    storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                        if let error = error{
                            print("Error: \(error)")
                        }
                        if let data = data{
                            newItem.sofaImage = UIImage(data: data)
                            self.searchedCollecton.reloadData()
                        }
                    }
                    if name.lowercased().contains(text.lowercased()) || type.lowercased().contains(text.lowercased()) {
                        self.itemArray.append(newItem)                    }
                }
                SVProgressHUD.dismiss()
                self.productsLabel.text = "\(self.itemArray.count) products found for \(self.searchBar.text!)"
            }
            
        }
        searchedCollecton.reloadData()
    }
    
    //MARK: - Fetching filtered Data
    
    func searchFilteredData(for array : [String] = [""], price : [String : Double] = [:])
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundColor(UIColor.white)
        SVProgressHUD.setForegroundColor(UIColor.orange)
        if array.count > 0 {
            for text in array {
                db.collection("products").getDocuments { (querySnapshot, err) in
                    self.itemArray.removeAll()
                    if let err = err{
                        print("Error getting documents \(err)")
                    }
                    else{
                        for document in querySnapshot!.documents{
                            var image : UIImage?
                            let newItem = Items()
                            let name = (document.data()["name"] as! String)
                            newItem.sofaName = name
                            let price = (document.data()["price"] as! Double)
                            newItem.sofaPrice = price
                            let type = (document.data()["type"] as! String)
                            newItem.sofaType = type
                            let color = (document.data()["color"] as! String)
                            newItem.sofaColor = color
                            let weight = (document.data()["weight"] as! String)
                            newItem.sofaWeight = weight
                            self.searchedCollecton.reloadData()
                            let storageRef = Storage.storage().reference(withPath: "products/\(document.documentID).png")
                            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                                if let error = error{
                                    print("Error: \(error)")
                                }
                                if let data = data{
                                    newItem.sofaImage = UIImage(data: data)
                                    self.furnitureCollection.reloadData()
                                }
                            }
                            if name.lowercased().contains(text.lowercased()) || type.lowercased().contains(text.lowercased()) {
                                self.itemArray.append(newItem)
                                self.searchedCollecton.reloadData()
                            }
                        }
                        //self.searchedCollecton.reloadData()
                        self.productsLabel.text = "\(self.itemArray.count) products found"
                    }
                    SVProgressHUD.dismiss()
                }
                searchedCollecton.reloadData()
            }
        }
        print(price.count)
        if price.count == 2 {
            db.collection("products").getDocuments { (querySnapshot, err) in
                self.itemArray.removeAll()
                if let err = err{
                    print("Error getting documents \(err)")
                }
                else{
                    for document in querySnapshot!.documents{
                        let newItem = Items()
                        let price = (document.data()["price"] as! Double)
                        newItem.sofaPrice = price
                        if newItem.sofaPrice >= self.filteredPrice["min"]! && newItem.sofaPrice <= self.filteredPrice["max"]! {
                            print(newItem.sofaPrice)
                            let name = (document.data()["name"] as! String)
                            newItem.sofaName = name
                            
                            let type = (document.data()["type"] as! String)
                            newItem.sofaType = type
                            let color = (document.data()["color"] as! String)
                            newItem.sofaColor = color
                            let weight = (document.data()["weight"] as! String)
                            newItem.sofaWeight = weight
                            self.searchedCollecton.reloadData()
                            let storageRef = Storage.storage().reference(withPath: "products/\(document.documentID).png")
                            storageRef.getData(maxSize: 4 * 1024 * 1024) { (data, error) in
                                if let error = error{
                                    print("Error: \(error)")
                                }
                                if let data = data{
                                    newItem.sofaImage = UIImage(data: data)
                                    self.searchedCollecton.reloadData()
                                }
                            }
                        }
                        if newItem.sofaName.count != 0 {
                            print(newItem.sofaPrice)
                            self.itemArray.append(newItem)
                        }
                    }
                    self.searchedCollecton.reloadData()
                    self.productsLabel.text = "\(self.itemArray.count) products found"
                }
            }
            searchedCollecton.reloadData()
        }
        }
        
    
    //MARK: - Filter Action
    
    @IBAction func addToCartButton(_ sender: UIButton) {
        let cartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(cartVC, animated: true)
    }
    @IBAction func filterButton(_ sender: Any) {
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
}

// MARK: - CollectionView Delegates and DataSource

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == furnitureCollection {
            let cell = furnitureCollection.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
            cell.sofaNameLabel.text = itemArray[indexPath.row].sofaName
            cell.sofaTypeLabel.text = itemArray[indexPath.row].sofaType
            cell.sofaPriceLabel.text = "Rp "+String(itemArray[indexPath.row].sofaPrice)
            cell.sofaImageView.image = itemArray[indexPath.row].sofaImage
            return cell
        }
        else{
            let cell = searchedCollecton.dequeueReusableCell(withReuseIdentifier: "SearchedCell", for: indexPath) as! SearchedCell
            cell.searchedName.text = itemArray[indexPath.row].sofaName
            cell.searchedType.text = itemArray[indexPath.row].sofaType
            cell.searchedPrice.text = "Rp "+String(itemArray[indexPath.row].sofaPrice)
            cell.searchedImage.image = itemArray[indexPath.row].sofaImage
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let descVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDescriptionVC") as! ProductDescriptionVC
        if collectionView == self.searchedCollecton {
            descVC.descName = itemArray[indexPath.row].sofaName
            descVC.descType = itemArray[indexPath.row].sofaType
            descVC.descImage = itemArray[indexPath.row].sofaImage
            descVC.descColor = itemArray[indexPath.row].sofaColor
            descVC.descWeight = itemArray[indexPath.row].sofaWeight
            descVC.descPrice = itemArray[indexPath.row].sofaPrice
            navigationController?.pushViewController(descVC, animated: true)
        }
        else {
            descVC.descName = itemArray[indexPath.row].sofaName
            descVC.descType = itemArray[indexPath.row].sofaType
            descVC.descImage = itemArray[indexPath.row].sofaImage
            descVC.descColor = itemArray[indexPath.row].sofaColor
            descVC.descWeight = itemArray[indexPath.row].sofaWeight
            descVC.descPrice = (itemArray[indexPath.row].sofaPrice)
            navigationController?.pushViewController(descVC, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
