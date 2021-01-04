//
//  ViewController.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 15/08/20.
//

import UIKit
import FirebaseAuth
import Alamofire
import SwiftyJSON
import SVProgressHUD

class SignInVC: UIViewController {
    
    @IBOutlet weak var lbl_donthaveaccount: UILabel!{
        didSet{
            lbl_donthaveaccount.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    
    @IBOutlet weak var lbl_phone: UILabel!{
        didSet{
            lbl_phone.setDynamicRegularFont(fontsize: 12)
        }
    }
    @IBOutlet weak var lbl_signUp: UILabel!{
        didSet{
            lbl_signUp.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    @IBOutlet weak var img_country: UIImageView!
    @IBOutlet weak var btn_country: UIButton!
    
    @IBOutlet weak var txt_phone: UITextField!{
        didSet{
            txt_phone.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    
    @IBOutlet weak var btn_signin: UIButton!{
        didSet{
            btn_signin.setDynamicRegularFont(fontsize: 14)
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        arr_userData = getProfileData()
        
        if arr_userData!.count != 0{
            moveToNext()
            addDevice()
        }
        
        getCountryList()
        
        let labels = getLabelsInView(view: view)
        
//        txt_phone.text = "9722109527"
        
//        getDetails()
        
        for label in labels{
            if label.tag == 1{
                applyGradient(view: label, colours: [UIColor.appColor(.gray)!,UIColor.clear])
            }
            else if label.tag == 2{
                
                applyGradient(view: label, colours: [UIColor.clear,UIColor.appColor(.gray)!])
            }
        }
        
        let textFields = getTextfieldsInView(view: view)
        
        for textField in textFields{
            textField.changePlaceholderColor(color: UIColor.appColor(.gray)!)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(action_countrySelect(notification:)), name: .selectCountry, object: nil)
        
    }
    
    @objc func action_countrySelect(notification:Notification) -> Void {
        let userData = notification.userInfo! as NSDictionary
        print(userData)
        selected_Country = userData.value(forKey: "country") as! String
        selected_CountryCode = userData.value(forKey: "c_code") as! String
        let svgURL = URL(string: "\(userData.value(forKey: "img") ?? "")")!
        img_country.sd_setImage(with: svgURL)
    }
    
    func moveToNext(){
        self.txt_phone.text = ""
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SocialVC = storyboard.instantiateViewController(withIdentifier: "SocialVC") as! SocialVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func action_signup(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: SignUpVC = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }


    fileprivate func moveToOTP() {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: OTPVC = storyboard.instantiateViewController(withIdentifier: "OTPVC") as! OTPVC
        vc.phoneNumber = txt_phone.text!
        vc.callbackClosureSurvey = {
            self.moveToNext()
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    fileprivate func sentOTP() {
        SVProgressHUD.show(withStatus: "Sending OTP on your mobile number")
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(selected_CountryCode)\(txt_phone.text!)", uiDelegate: nil) { [self] (verificationID, error) in
            if let error = error {
                self.dissmissProgress()
                self.alert(message: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            
            self.dissmissProgress()
            
            moveToOTP()
            
        }
    }
    
    @IBAction func action_login(_ sender: Any) {
        self.view.endEditing(true)
        if self.txt_phone.text!.count == 0{
            alert(message: "Please enter mobile number")
        }
        else if self.txt_phone.text!.count < 8{
            alert(message: "Please enter valid mobile number")
        }
        else{
            if testUserNumbers.contains(txt_phone.text!){
                selected_CountryCode = "91"
                moveToOTP()
                return
            }
            verifyMobile()
        }
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
    
    
    func signIN(credential: PhoneAuthCredential){
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error == nil{
                self.getDetails()
            }
            else{
                self.alert(message: error!.localizedDescription)
            }
        }
    }
    
    
    func verifyMobile()
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: "\(api_verifyMobile)")!
//            self.showProgress()
            SVProgressHUD.show(withStatus: "Verifying Mobile Number")
            
            let param = ["code" : selected_CountryCode, "mobile" : txt_phone.text!]
            
            Alamofire.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
                switch response.result {
                case .success:
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let json = JSON(value)
                            if json["isRegister"].stringValue == "true"{
                                self.sentOTP()
                            }
                            else{
//                                SVProgressHUD.showInfo(withStatus: "Mobile verification failed")
                                SVProgressHUD.showError(withStatus: json["message"].stringValue)
                                SVProgressHUD.dismiss(withDelay: 1.0)
//                                self.alert(message: json["message"].stringValue)
                            }
                        }
                        
                    }
                case .failure:
                    self.dissmissProgress()
                    self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                        
                        },{action2 in
                            self.verifyMobile()
                        }, nil])
                }
            }
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
                },{action2 in
                    self.verifyMobile()
                }, nil])
        }
    }
    
    func getDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: "\(api_getUserDetails)")!
            self.showProgress()
            
            Alamofire.request(url, method: .get, parameters: ["code" : selected_CountryCode, "mobile" : txt_phone.text!], encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
                switch response.result {
                case .success:
                    self.dissmissProgress()
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let json = JSON(value)
                            if json["type"].stringValue == "success"{
                                self.setProfileData(arr: json["data"])
                                self.moveToNext()
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
    
    
    func getCountryList()
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: api_country)!
//            self.showProgress()
            SVProgressHUD.show(withStatus: "Getting country list")
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
                switch response.result {
                case .success:
                    self.dissmissProgress()
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let json = JSON(value)
                            arr_countries = json
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
                        
                    }
                case .failure:
                    self.dissmissProgress()
                    self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                        
                        },{action2 in
                            self.getCountryList()
                        }, nil])
                }
            }
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
                },{action2 in
                    self.getCountryList()
                }, nil])
        }
    }
    
    
}
