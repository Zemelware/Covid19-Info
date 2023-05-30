//
//  CustomCollectionViewCell.swift
//  Covid19 Info
//
//  Created by Ethan Zemelman on 2020-08-12.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var factLabel: UILabel!
    @IBOutlet weak var fact: UILabel!
 
    override func awakeFromNib() {
        // Make the cards look nicer
        layer.cornerRadius = 15
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
    }
    
}
