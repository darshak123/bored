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

class OTPVC: UIViewController {
    
    @IBOutlet weak var lbl_otp: UILabel!{
        didSet{
            lbl_otp.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    @IBOutlet weak var txt_otp: UITextField!{
        didSet{
            txt_otp.setDynamicRegularFont(fontsize  : 14)
        }
    }
    
    @IBOutlet weak var btn_signin: UIButton!{
        didSet{
            btn_signin.setDynamicRegularFont(fontsize: 14)
            
        }
    }
    @IBOutlet weak var btn_resendOTP: UIButton!{
        didSet{
            btn_resendOTP.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    var callbackClosureSurvey: (()->())?
    
    var gameTimer: Timer?

    
    @IBOutlet weak var view_main: UIView!
    
    var phoneNumber = ""
    var countryCode = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let labels = getLabelsInView(view: view)
        
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
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        
        initTimer()

        btn_resendOTP.isEnabled = false
        btn_resendOTP.alpha = 0.3
        
    }
    
    func initTimer(){
        var seconds = 30
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            seconds = seconds - 1
            self.btn_resendOTP.setTitle("\(seconds)", for: .normal)
            if seconds == 1{
                timer.invalidate()
                self.btn_resendOTP.isEnabled = true
                self.btn_resendOTP.alpha = 1
                self.btn_resendOTP.setTitle("Resend", for: .normal)
            }
        }
    }
    
    
    func moveToNext(){
        self.txt_otp.text = ""
        self.dismiss(animated: true) {
            self.callbackClosureSurvey?()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view_main.roundCorners([.topLeft,.topRight], radius: 15)
    }

    @IBAction func action_login(_ sender: Any) {
        self.view.endEditing(true)
        if self.txt_otp.text!.count == 0 ||  self.txt_otp.text!.count < 6{
            alert(message: "Please enter valid OTP")
        }
        else {
            if testUserNumbers.contains(phoneNumber){
                if txt_otp.text != "112233"{
                    alert(message: "Please enter valid OTP")
                    return
                }
                else{
                    selected_CountryCode = "91"
                    self.getDetails()
                    return
                }
            }
            let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID!,
                verificationCode: txt_otp.text!)
            self.signIN(credential: credential)
        }
        
    }
    
    @IBAction func action_resendOTP() {
        
        SVProgressHUD.show(withStatus: "Sending OTP on your mobile number")
        PhoneAuthProvider.provider().verifyPhoneNumber("+\(selected_CountryCode)\(phoneNumber)", uiDelegate: nil) { [self] (verificationID, error) in
            if let error = error {
                self.dissmissProgress()
                self.alert(message: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            initTimer()
            self.dissmissProgress()
            
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
        showProgress()
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if error == nil{
                self.getDetails()
            }
            else{
                self.dissmissProgress()
                self.alert(message: error!.localizedDescription)
            }
        }
    }
    
    
    func getDetails()
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: "\(api_getUserDetails)")!
            self.showProgress()
            
            Alamofire.request(url, method: .get, parameters: ["code" : selected_CountryCode, "mobile" : phoneNumber], encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
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
    
}
