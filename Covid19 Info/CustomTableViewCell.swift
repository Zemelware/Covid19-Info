//
//  CustomTableViewCell.swift
//  Covid19 Info
//
//  Created by Ethan Zemelman on 2020-08-13.
//  Copyright © 2020 Ethan Zemelman. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var totalCases: UILabel!
    @IBOutlet weak var deaths: UILabel!
    @IBOutlet weak var recovered: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
