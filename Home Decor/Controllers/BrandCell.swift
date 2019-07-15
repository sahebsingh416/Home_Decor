//
//  BrandCell.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 12/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class BrandCell: UICollectionViewCell {
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    @IBAction func checkButton(_ sender: Any) {
        checkImage.isHidden.toggle()
    }
}
