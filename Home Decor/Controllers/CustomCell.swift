//
//  CustomCell.swift
//  Home Decor
//
//  Created by Saheb Singh Tuteja on 09/07/19.
//  Copyright © 2019 Solution Analysts. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    @IBOutlet weak var sofaImageView: UIImageView!
    @IBOutlet weak var sofaPriceLabel: UILabel!
    @IBOutlet weak var sofaNameLabel: UILabel!
    @IBOutlet weak var sofaTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
