//
//  AddTripVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 28/08/20.
//

import UIKit
import SwiftyJSON
import MessageUI
import Alamofire

class UserProfileVC: UIViewController {
    
    
    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var lbl_userName: UILabel!{
        didSet{
            lbl_userName.setDynamicRegularFont(fontsize: 16)
        }
    }
    
    @IBOutlet weak var img_user: UIImageView!
    
    @IBOutlet weak var lbl_wave: UILabel!{
        didSet{
            lbl_wave.setDynamicBoldFont(fontsize: 12)
        }
    }
    
    @IBOutlet weak var btn_back: UIButton!
    
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_previous: UIButton!
    
    @IBOutlet weak var btn_wp: UIButton!
    @IBOutlet weak var btn_ig: UIButton!
    @IBOutlet weak var btn_mail: UIButton!
    @IBOutlet weak var btn_twitter: UIButton!
    @IBOutlet weak var btn_fb: UIButton!
    
    var arr_images : JSON!
    var arr_user : JSON!
    
    var index = 0
    
    var fromNoti = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        hideKeyboardWhenTappedAround()
            
        if arr_images == nil{
            arr_images = arr_user["image"]
        }
        
        lbl_userName.text = arr_user["name"].stringValue
        bindValues()
        
        if fromNoti{
            btn_back.setImage(UIImage.init(named: "cancel"), for: .normal)
        }
        
        let labels = getLabelsInView(view: view)
        let textFields = getTextfieldsInView(view: view)
        
        for label in labels{
            if label.tag == 1{
                applyGradient(view: label, colours: [UIColor.appColor(.gray)!,UIColor.clear])
            }
            else if label.tag == 2{
                
                applyGradient(view: label, colours: [UIColor.clear,UIColor.appColor(.gray)!])
            }
            else if label.tag == 3{
                label.setDynamicRegularFont(fontsize: 12)
            }
        }
        
        for textfield in textFields{
            textfield.changePlaceholderColor(color: UIColor.white)
            textfield.setDynamicRegularFont(fontsize: 14)
        }

        
    }
    
    
    
    @IBAction func action_next(_ sender: Any) {
        if index < arr_images.count - 1 {
            index = index + 1
            bindValues()
        }
    }
    
    @IBAction func action_previous(_ sender: Any) {
        if index > 0 {
            index = index - 1
            bindValues()
        }
    }
    
    
    func bindValues(){
        
        if arr_images.count == 0{
            img_user.sd_setImage(with: URL.init(string: defaultAvatar), completed: nil)
        }
        else{
            img_user.sd_setImage(with: URL.init(string: arr_images[index]["thumb"].stringValue), completed: nil)
        }
        
        if arr_user["social"]["facebook"].stringValue != ""{
            btn_fb.isEnabled = true
            btn_fb.alpha = 1
        }
        else{
            btn_fb.alpha = 0.2
        }
        if arr_user["social"]["twitter"].stringValue != ""{
            btn_twitter.isEnabled = true
            btn_twitter.alpha = 1
        }
        else{
            btn_twitter.alpha = 0.2
        }
        if arr_user["social"]["instagram"].stringValue != ""{
            btn_ig.isEnabled = true
            btn_ig.alpha = 1
        }
        else{
            btn_ig.alpha = 0.2
        }
        if arr_user["social"]["whatsapp"].stringValue != ""{
            btn_wp.isEnabled = true
            btn_wp.alpha = 1
        }
        else{
            btn_wp.alpha = 0.2
        }
        
        if index == 0{
            btn_next.isEnabled = true
            btn_previous.isEnabled = false
            btn_next.alpha = 1
            btn_previous.alpha = 0.5
        }
        else if index == arr_images.count - 1{
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
        if arr_images.count == 1{
            btn_next.isEnabled = false
            btn_previous.isEnabled = false
            btn_next.alpha = 0.5
            btn_previous.alpha = 0.5
        }
    }
    
    
    @IBAction func action_back(_ sender: Any) {
        if fromNoti{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func action_image(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ImageController.className) as! ImageController
        controller.indexNumber = index
        controller.arr_images = arr_images
        controller.fromNoti = fromNoti
        if fromNoti{
            self.present(controller, animated: true, completion: nil)
        }
        else{
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    @IBAction func action_wp(_ sender: Any) {
        let phoneNumber = arr_user["social"]["whatsapp"].stringValue
        openWhatsApp(phoneNumber: phoneNumber)
    }
    
    @IBAction func action_ig(_ sender: Any) {
        let id = arr_user["social"]["instagram"].stringValue
        openInstagram(id: id)
    }
    
    @IBAction func action_tw(_ sender: Any) {
        sendTwitterMessage(screenName: arr_user["social"]["twitter"].stringValue)
    }
    
    @IBAction func action_mail(_ sender: Any) {
        let recipientEmail = arr_user["email"].stringValue
        sendMail(recipientEmail: recipientEmail)
    }
    @IBAction func action_fb(_ sender: Any) {
        let id = arr_user["social"]["facebook"].stringValue
        openFB(id: id)
    }
    
    
    
    @IBAction func action_wave(_ sender: Any) {
        sendWave(userID: "\(arr_user["id"])")
    }
    
    
    func sendWave(userID: String){
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: "\(api_sendNotification)/\(userID)/\(arr_userData["id"])")!
            self.showProgress()
            
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
                switch response.result {
                case .success:
                    self.dissmissProgress()
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let json = JSON(value)
                            if json["type"].stringValue == "success"{
                                
                            }
                            self.alert(message: json["message"].stringValue)
                        }
                        
                    }
                case .failure:
                    self.dissmissProgress()
                    self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                        
                        },{action2 in
                            self.sendWave(userID: userID)
                        }, nil])
                }
            }
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
                },{action2 in
                    self.sendWave(userID: userID)
                }, nil])
        }
    }
    
}
