//
//  ChildActivityVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 22/08/20.
//

import UIKit
import SwiftyJSON

class ChildActivityVC: UIViewController {
    
    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var lbl_title: UILabel!{
        didSet{
            lbl_title.setDynamicRegularFont(fontsize: 26)
        }
    }
    @IBOutlet weak var lbl_number: UILabel!{
        didSet{
            lbl_number.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    @IBOutlet weak var btn_done: UIButton!{
        didSet{
            btn_done.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_previous: UIButton!
    
    var curActivityIndex = 0
    
    var arr_activities : JSON = []
    
    @IBOutlet weak var tbl_childActivities: UITableView!{
        didSet{
            tbl_childActivities.register(UINib(nibName: ChildActivityCell.className, bundle: nil), forCellReuseIdentifier: ChildActivityCell.className)
            tbl_childActivities.estimatedRowHeight = 100
            tbl_childActivities.rowHeight = UITableView.automaticDimension
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindValues()
    }
    
    func bindValues(){
        lbl_title.text = "\(arr_activities[curActivityIndex]["name"])"
        lbl_number.text = "\(curActivityIndex+1)/\(arr_activities.count)"
        tbl_childActivities.reloadData()
        
        if curActivityIndex == 0{
            btn_next.isEnabled = true
            btn_previous.isEnabled = false
            btn_next.alpha = 1
            btn_previous.alpha = 0.5
        }
        else if curActivityIndex == arr_activities.count - 1{
            btn_next.isEnabled = false
            btn_previous.isEnabled = true
            btn_next.alpha = 0.5
            btn_previous.alpha = 1
        }
        else{
            btn_next.isEnabled = true
            btn_previous.isEnabled = true
            btn_next.alpha = 1
            btn_previous.alpha = 1
        }
    }
    
    @IBAction func action_next(_ sender: Any) {
        if curActivityIndex < arr_activities.count - 1 {
            curActivityIndex = curActivityIndex + 1
            bindValues()
        }
    }
    
    @IBAction func action_previous(_ sender: Any) {
        if curActivityIndex > 0 {
            curActivityIndex = curActivityIndex - 1
            bindValues()
        }
    }
    
    
    @IBAction func action_done(_ sender: Any) {
        NotificationCenter.default.post(name:Notification.Name(rawValue:"reason_activitySelect"),
                                        object: nil,
                                        userInfo: nil)
        
        self.dismiss(animated: true, completion: nil)
    }

}


extension ChildActivityVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_activities[curActivityIndex]["child"].count
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
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ChildActivityCell.className, for: indexPath) as! ChildActivityCell
        
        
        
        cell.lbl_title.text = arr_activities[curActivityIndex]["child"][indexPath.row]["name"].stringValue
        
        
        
        applyGradient(view: cell.lbl_bottomLeft, colours: [UIColor.appColor(.gray)!,UIColor.clear])
        applyGradient(view: cell.lbl_bottomRight, colours: [UIColor.clear,UIColor.appColor(.gray)!])
        
        if arr_selectedActivities.contains("\(arr_activities[curActivityIndex]["child"][indexPath.row]["name"])"){
            cell.img_activity.isHighlighted = true
            cell.img_activity.tintColor = UIColor.appColor(.mainColor)
            cell.lbl_title.textColor = UIColor.appColor(.gray)
        }
        else{
            cell.img_activity.isHighlighted = false
            cell.img_activity.tintColor = UIColor.appColor(.gray)
            cell.lbl_title.textColor = UIColor.appColor(.white)
        }
        
        if arr_activities[curActivityIndex]["child"].count - 1 == indexPath.row{
            cell.lbl_bottomLeft.isHidden = true
            cell.lbl_bottomRight.isHidden = true
        }
        else{
            cell.lbl_bottomLeft.isHidden = false
            cell.lbl_bottomRight.isHidden = false
        }
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var arr_childActivity : NSMutableArray = []
        
        if arr_selectedActivitiesIds["\(arr_activities[curActivityIndex]["id"])"] != nil{
            arr_childActivity = arr_selectedActivitiesIds.value(forKey: "\(arr_activities[curActivityIndex]["id"])") as! NSMutableArray
        }
        
        if arr_selectedActivities.contains("\(arr_activities[curActivityIndex]["child"][indexPath.row]["name"])"){
            arr_selectedActivities.remove("\(arr_activities[curActivityIndex]["child"][indexPath.row]["name"])")
            arr_childActivity.remove(arr_activities[curActivityIndex]["child"][indexPath.row]["id"].intValue)
        }
        else{
            arr_childActivity.add(arr_activities[curActivityIndex]["child"][indexPath.row]["id"].intValue)
            arr_selectedActivities.add("\(arr_activities[curActivityIndex]["child"][indexPath.row]["name"])")
        }
        
        if arr_childActivity.count == 0{
            arr_selectedActivitiesIds.removeObject(forKey: "\(arr_activities[curActivityIndex]["id"])")
        }
        else{
            arr_selectedActivitiesIds.setValue(arr_childActivity, forKey: "\(arr_activities[curActivityIndex]["id"])")
        }
        
        tbl_childActivities.reloadRows(at: [indexPath], with: .none)
        
    }
    
}
