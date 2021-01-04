//
//  TableViewCell.swift
//  SideMenuUsingXIB
//
//  Created by Jainish on 25/12/17.
//  Copyright © 2017 Assure live technology. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var img_icon_2: UIImageView!
    @IBOutlet var lblTitle: UILabel!{
        didSet{
            lblTitle.setDynamicRegularFont(fontsize: 13)
        }
    }
    @IBOutlet var lbl_seprator: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lbl_seprator.backgroundColor = UIColor.appColor(.seprator)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
