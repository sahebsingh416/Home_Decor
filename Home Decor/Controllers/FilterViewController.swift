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
    @IBOutlet var categoryLabels: [UILabel]!
    
    var textToSearch = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Fabric.sharedSDK().debug = true
        for images in checkedImages {
            images.image = UIImage(named: "Check")
        }
        for images in categoryImages {
            images.image = UIImage(named: "Check")
        }
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func checkCategory(_ sender: UIButton) {
        checkCategory(value: sender.tag-9)
        textToSearch.append(categoryLabels[sender.tag-1].text!)
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        checked(value: sender.tag-1)
        textToSearch.append(categoryLabels[sender.tag-1].text!)
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
        
        UserDefaults.standard.set(textToSearch, forKey: "dataToFilter")
        self.navigationController?.popViewController(animated: true)

    }
}

