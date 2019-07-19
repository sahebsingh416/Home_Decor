//
//  FilterViewController.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 12/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import Fabric

class FilterViewController: UIViewController {
    
    @IBOutlet var checkedImages: [UIImageView]!
    @IBOutlet var categoryImages: [UIImageView]!
    @IBOutlet var checkedLabels: [UILabel]!
    @IBOutlet weak var minimumPrice: UITextField!
    @IBOutlet weak var maximumPrice: UITextField!
    
    var textToSearch = [String]()
    var priceToFilter = [String : Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        for images in checkedImages {
            images.image = UIImage(named: "orange")
            images.isHidden = true
        }
        for images in categoryImages {
            images.image = UIImage(named: "orange")
            images.isHidden = true
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textToSearch = []
        priceToFilter = [:]
    }
    
    @IBAction func checkCategory(_ sender: UIButton) {
        checkCategory(value: sender.tag-9)
        textToSearch.append(checkedLabels[sender.tag-1].text!)
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        checked(value: sender.tag-1)
        textToSearch.append(checkedLabels[sender.tag-1].text!)
    }
    
    func checkCategory(value: Int) {
        categoryImages[value].isHidden.toggle()
    }
    
    func checked(value: Int) {
        checkedImages[value].isHidden.toggle()
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        textToSearch.removeAll()
    }
    
    @IBAction func resetButton(_ sender: Any) {
        for images in checkedImages {
            images.isHidden = true
        }
        textToSearch.removeAll()
        for images in categoryImages {
            images.isHidden = true
        }
    }
    
    @IBAction func applyAction(_ sender: Any) {
        if (minimumPrice.text?.count)! > 0 && (maximumPrice.text?.count)! > 0 {
            priceToFilter["min"] = Double(minimumPrice.text!)!
            priceToFilter["max"] = Double(maximumPrice.text!)!
            UserDefaults.standard.set(priceToFilter, forKey: "filteredPrice")
        }
        if textToSearch.count > 0 {
            UserDefaults.standard.set(textToSearch, forKey: "dataToFilter")
        }
        self.navigationController?.popViewController(animated: true)

    }
}

