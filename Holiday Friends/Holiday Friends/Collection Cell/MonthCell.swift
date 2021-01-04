//
//  MonthCell.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 08/10/20.
//

import UIKit

class MonthCell: UICollectionViewCell {

    
    @IBOutlet weak var lbl_title: UILabel!{
        didSet{
            lbl_title.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
