//
//  SelectionCell.swift
//  Corona Response
//
//  Created by KD Kankotiya on 03/04/20.
//  Copyright © 2020 KD Kankotiya. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {
    
    @IBOutlet var lbl_title: UILabel!
    @IBOutlet var img_country: UIImageView!
    @IBOutlet var lbl_sep: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
