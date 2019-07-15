//
//  FilterViewController.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 12/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit
import BottomDrawer
import Fabric

class FilterViewController: BottomController {
    
    @IBOutlet var checkedImages: [UIImageView]!
    @IBOutlet var categoryImages: [UIImageView]!
    
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
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        checked(value: sender.tag-1)
    }
    
    func checkCategory(value: Int) {
        categoryImages[value].isHidden.toggle()
    }
    
    func checked(value: Int) {
        checkedImages[value].isHidden.toggle()
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButton(_ sender: Any) {
        for images in checkedImages {
            images.isHidden = true
        }
        for images in categoryImages {
            images.isHidden = true
        }
    }
    
    @IBAction func applyAction(_ sender: Any) {
        
        
        dismiss(animated: true, completion: nil)
        
    }
}

