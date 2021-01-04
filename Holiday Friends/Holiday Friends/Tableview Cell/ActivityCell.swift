//
//  ActivityCell.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 22/08/20.
//

import UIKit

class ActivityCell: UITableViewCell {
    
    @IBOutlet weak var img_activity: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!{
        didSet{
            lbl_title.setDynamicBoldFont(fontsize: 14)
        }
    }
    @IBOutlet weak var lbl_count: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
