//
//  PopUpVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 24/11/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class PopUpVC: UIViewController {

    @IBOutlet weak var lbl_main: UILabel!
    
    @IBOutlet weak var txt_id: UITextField!
    
    @IBOutlet weak var img_icon: UIImageView!
    
    var popUpFor : social = .whatsapp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchHappen(_:)))
        lbl_main.addGestureRecognizer(tap)
        
        if popUpFor == .whatsapp{
            txt_id.placeholder = "Enter your whatsapp number"
            img_icon.image = UIImage.init(named: "wp big")
        }
        else{
            txt_id.placeholder = "Enter your instagram id"
            img_icon.image = UIImage.init(named: "ig big")
        }
        
        txt_id.changePlaceholderColor(color: .white)
        
    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func action_submit(_ sender: Any) {
        if txt_id.text?.count == 0{
            if popUpFor == .whatsapp{
                alert(message: "Please enter whatsapp number")
            }
            else{
                alert(message: "Please enter instagram id")
            }
        }
        else{
            if popUpFor == .whatsapp{
                sendPrivateData(showProgree: true, key: "whatsapp", value: txt_id.text!)
            }
            else{
                sendPrivateData(showProgree: true, key: "instagram", value: txt_id.text!)
            }
        }
    }
    
    func sendPrivateData(showProgree: Bool, key: String, value: String){
        if Reachability.isConnectedToNetwork()
        {
            self.showProgress()
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr_selectedActivitiesIds, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print(jsonString!)
            
            let params    = ["userid" : "\(arr_userData["id"])", "key" : "\(key)", "value" : "\(value)"] as [String : Any]
            
            
            
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
            },
                to: "\(api_addSocial)",
                headers: Auth_header,
                encodingCompletion: { encodingResult in
                    
                    
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.dissmissProgress()
                            if let value = response.result.value {
                                let json = JSON(value)
                                if "\(json["status"])" == "201"
                                {
                                    self.alert(message: json["message"].string!)
                                }
                                else
                                {
                                    NotificationCenter.default.post(name:Notification.Name(rawValue:"reloadSocialData"),
                                                                    object: nil,
                                                                    userInfo: nil)
                                    let refreshAlert = UIAlertController(title: nil, message: json["message"].string!, preferredStyle: UIAlertController.Style.alert)
                                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                            self.dismiss(animated: true, completion: nil)
                                        }))
                                        self.present(refreshAlert, animated: true, completion: nil)
                                }
                            }
                            
                            
                            
                        }
                    case .failure( _):
                        self.dissmissProgress()
                        self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                            
                            },{action2 in
    self.sendPrivateData(showProgree: showProgree, key: key, value: value)
                            }, nil])
                    }
            }
            )
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
                },{action2 in
    self.sendPrivateData(showProgree: showProgree, key: key, value: value)
                }, nil])
        }
    }
}
