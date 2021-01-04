//
//  SignUpVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 19/08/20.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignUpVC: UIViewController {
    
    @IBOutlet weak var img_country: UIImageView!
    @IBOutlet weak var btn_country: UIButton!

    @IBOutlet weak var btn_back: UIButton!
    @IBOutlet weak var btn_signup: UIButton!{
        didSet{
            btn_signup.setDynamicBoldFont(fontsize: 14)
        }
    }
    @IBOutlet weak var txt_name: UITextField!{
        didSet{
            txt_name.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var txt_email: UITextField!{
        didSet{
            txt_email.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var txt_number: UITextField!{
        didSet{
            txt_number.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var txt_password: UITextField!{
        didSet{
            txt_password.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var constrain_height: NSLayoutConstraint!{
        didSet{
            if screenWidth < 380 {
                constrain_height.constant = 104
            }
        }
    }
    @IBOutlet weak var img_user: UIImageView!{
        didSet{
            if screenWidth < 380 {
                img_user.setRadius(52)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        hideKeyboardWhenTappedAround()
        
//        txt_name.text = "Keyur"
//        txt_email.text = "Keyur@gmail.com"
//        txt_password.text = "Admin@0405"
//        txt_number.text = "9722109523"
        
        let labels = getLabelsInView(view: view)
        
        for label in labels{
            if label.tag == 1{
                applyGradient(view: label, colours: [UIColor.appColor(.gray)!,UIColor.clear])
            }
            else if label.tag == 2{
                applyGradient(view: label, colours: [UIColor.clear,UIColor.appColor(.gray)!])
            }
            else if label.tag == 3{
                label.setDynamicRegularFont(fontsize: 12)
                label.textColor = .white
            }
            else if label.tag == 4{
                label.setDynamicRegularFont(fontsize: 12)
            }
        }
        
        let textFields = getTextfieldsInView(view: view)
        
        for textField in textFields{
            textField.changePlaceholderColor(color: UIColor.appColor(.gray)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(action_countrySelect(notification:)), name: .selectCountry, object: nil)
        
        let arrTemp : NSArray = arr_countries.arrayObject! as NSArray
        let predicate = NSPredicate(format: "alpha2Code == %@", Locale.current.regionCode!);
        let temp = JSON(arrTemp.filtered(using: predicate))
        if temp.count > 0{
            selected_Country = temp[0]["name"].stringValue
            selected_CountryCode = temp[0]["callingCodes"][0].stringValue
            let svgURL = URL(string: "\(temp[0]["flag"])")!
            self.img_country.sd_setImage(with: svgURL)
        }
        
    }
    
    
    @objc func action_countrySelect(notification:Notification) -> Void {
        let userData = notification.userInfo! as NSDictionary
        print(userData)
        selected_Country = userData.value(forKey: "country") as! String
        selected_CountryCode = userData.value(forKey: "c_code") as! String
        let svgURL = URL(string: "\(userData.value(forKey: "img") ?? "")")!
        img_country.sd_setImage(with: svgURL)
    }
    
    
    @IBAction func action_country(_ sender: Any) {
        
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: SingleSelectionVC.className) as! SingleSelectionVC
        controller.array_display = arr_countries
        controller.cur_value = selected_Country
        controller.searchEnable = true
        controller.tbl_title = "Select Country"
        controller.notiName = Notification.Name.selectCountry
        if #available(iOS 13.0, *) {
            controller.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    @IBAction func action_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_continue(_ sender: Any) {
        if txt_name.text?.count == 0{
            alert(message: "Please enter your name")
        }
        else{
            if txt_email.text?.count == 0{
                alert(message: "Please enter Email Address")
            }
            else if !isValidEmail(email: txt_email.text!){
                alert(message: "Please enter valid Email Address")
            }
            else{
                if txt_password.text?.count == 0{
                    alert(message: "Please enter Password")
                }
                else if txt_password.text!.count < 7{
                    alert(message: "Password must be at least 8 characters long")
                }
                else{
                    if txt_number.text?.count == 0{
                        alert(message: "Please enter Mobile Number")
                    }
                    else if txt_number.text!.count < 9{
                        alert(message: "Please enter valid Mobile Number")
                    }
                    else{
                        registerUser()
                    }
                }
            }
        }
    }
    
    func registerUser()
    {
        if Reachability.isConnectedToNetwork()
        {
            self.showProgress()
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr_selectedActivitiesIds, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print(jsonString!)
            
            let params    = ["name":txt_name.text!,"email": txt_email.text!,"password": txt_password.text!,"mobile" : txt_number.text!,"country" : selected_Country,"code" : selected_CountryCode] as [String : Any]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
            },
                to: "\(api_signUp)",
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
                                    let json = JSON(value)
                                    if json["type"].stringValue == "success"{
                                        self.popupAlertWithButton(actionTitles: ["Ok"], actionMessage: json["message"].stringValue, actions: [{action1 in
                                            self.btn_back.sendActions(for: .touchUpInside)
                                        }, nil])
                                    }
                                    else{
                                        self.alert(message: json["message"].stringValue)
                                    }
                                }
                            }
                            
                            
                            
                        }
                    case .failure( _):
                        self.dissmissProgress()
                        self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                            
                            },{action2 in
                                self.registerUser()
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
                    self.registerUser()
                }, nil])
        }
    }

}
