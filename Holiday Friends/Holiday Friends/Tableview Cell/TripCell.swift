//
//  TripCell.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 18/09/20.
//

import UIKit

class TripCell: UITableViewCell {
    
    @IBOutlet weak var lbl_date: UILabel!{
        didSet{
            lbl_date.setDynamicRegularFont(fontsize: 12)
        }
    }
    @IBOutlet weak var lbl_title: UILabel!{
        didSet{
            lbl_title.setDynamicBoldFont(fontsize: 16)
        }
    }
    @IBOutlet weak var lbl_activity: UILabel!{
        didSet{
            lbl_activity.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var lbl_location: UILabel!{
        didSet{
            lbl_location.setDynamicRegularFont(fontsize: 13)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
