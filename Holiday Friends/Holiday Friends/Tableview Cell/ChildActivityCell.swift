//
//  ChildActivityCell.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 23/08/20.
//

import UIKit

class ChildActivityCell: UITableViewCell {
    
    @IBOutlet weak var img_activity: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!{
        didSet{
            lbl_title.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var lbl_bottomRight: UILabel!
    @IBOutlet weak var lbl_bottomLeft: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
