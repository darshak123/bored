//
//  ActivityVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 22/08/20.
//

import UIKit
import SwiftyJSON
import SDWebImage

class ActivityVC: UIViewController {
    
    let arr_activities : JSON = []
    
    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicBoldFont(fontsize: 18)
        }
    }
    
    @IBOutlet weak var tbl_activities: UITableView!{
        didSet{
            tbl_activities.register(UINib(nibName: ActivityCell.className, bundle: nil), forCellReuseIdentifier: ActivityCell.className)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
}


extension ActivityVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_activities.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 15))
        viewHeader.backgroundColor = .clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewHeader = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 15))
        viewHeader.backgroundColor = .clear
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return bottomSafeAreaHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ActivityCell.className, for: indexPath) as! ActivityCell
        
        cell.img_activity.sd_setImage(with: URL.init(string: "\(arr_activities[indexPath.row]["image"])"), completed: nil)
        
        cell.lbl_title.text = "\(arr_activities[indexPath.row]["title"])"
        cell.lbl_count.text = "\(arr_activities[indexPath.row]["count"])"
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ChildActivityVC = storyboard.instantiateViewController(withIdentifier: "ChildActivityVC") as! ChildActivityVC
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    
}
