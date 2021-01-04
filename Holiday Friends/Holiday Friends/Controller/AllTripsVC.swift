//
//  AllTripsVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 18/09/20.
//

import UIKit
import SwiftyJSON
import Alamofire

class AllTripsVC: BaseViewController {
    
    @IBOutlet weak var view_header: UIView!
    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var tbl_trips: UITableView!{
        didSet{
            tbl_trips.register(UINib(nibName: TripCell.className, bundle: nil), forCellReuseIdentifier: TripCell.className)
            tbl_trips.estimatedRowHeight = 100
            tbl_trips.rowHeight = UITableView.automaticDimension
        }
    }
    
    var all_trips : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSlideMenuButton(header_view: view_header)
        
        getDetails()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func getDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: "\(api_userDetails)\(arr_userData["id"])")!
            self.showProgress()
            
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
                switch response.result {
                case .success:
                    self.dissmissProgress()
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let json = JSON(value)
                            if json["type"].stringValue == "success"{
                                self.setProfileData(arr: json["data"])
                                self.all_trips = json["data"]["trip"]
                                self.tbl_trips.reloadData()
                            }
                            else{
                                self.alert(message: json["message"].stringValue)
                            }
                        }
                        
                    }
                case .failure:
                    self.dissmissProgress()
                    self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                        
                        },{action2 in
                            self.getDetails()
                        }, nil])
                }
            }
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
                },{action2 in
                    self.getDetails()
                }, nil])
        }
    }
    

}


extension AllTripsVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return all_trips.count
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
        return 15
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: TripCell.className, for: indexPath) as! TripCell
        
        cell.lbl_title.text = all_trips[indexPath.row]["title"].stringValue
        cell.lbl_location.text = "\(all_trips[indexPath.row]["city"]), \(all_trips[indexPath.row]["state"]), \(all_trips[indexPath.row]["country"])"
        cell.lbl_date.text = all_trips[indexPath.row]["date"].stringValue
        cell.lbl_activity.text = getAllActivities(arr: all_trips[indexPath.row]["activity"])
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func getAllActivities(arr: JSON) -> String{
        
        var activities = ""
        
        for act in arr{
            if activities == ""{
                activities = "\(act.1["name"])"
            }
            else{
                activities = "\(activities), \(act.1["name"])"
            }
        }
        
        return activities
    }
    
}
