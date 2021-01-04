//
//  SignUpVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 19/08/20.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Alamofire
import SwiftyJSON
import FirebaseAuth
import Firebase

class SocialVC: BaseViewController {

    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var view_userData: UIView!
    
    @IBOutlet weak var img_user: UIImageView!
    
    @IBOutlet weak var lbl_name: UILabel!{
        didSet{
            lbl_name.setDynamicRegularFont(fontsize: 12)
        }
    }
    @IBOutlet weak var view_info: UIView!
    @IBOutlet weak var view_header: UIView!
    
    @IBOutlet weak var lbl_message: UILabel!{
        didSet{
            lbl_message.setRegularFont(fontsize: 20)
            lbl_message.text = "All accounts are linked\nGo to setting page to change"
        }
    }
    
    @IBOutlet weak var view_fb: UIView!
    @IBOutlet weak var view_ig: UIView!
    @IBOutlet weak var view_wp: UIView!
    @IBOutlet weak var view_tw: UIView!
    
    @IBOutlet weak var btn_next: UIButton!
    
    @IBOutlet weak var lbl_hint: UILabel!{
        didSet{
            lbl_hint.setDynamicRegularFont(fontsize: 10)
        }
    }
    
    var fromMenu = false
    var allAdded = false
    
    private enum BaseURL: String {
      case displayApi = "https://api.instagram.com/"
      case graphApi = "https://graph.instagram.com/"
    }
    private enum Method: String {
      case authorize = "oauth/authorize"
      case access_token = "oauth/access_token"
    }
    
    var provider = OAuthProvider(providerID: "twitter.com")
    
    let TWITTER_CONSUMER_KEY = "iyEIaViKcnCh0jwwKPo21k20t"
    let TWITTER_CONSUMER_SECRET = "QPt7elne6lWkOLbUvUawYmuBghAImr9uGDxH94mb9mOT4jEa4U"
    let TWITTER_URL_SCHEME = "twittersdk"
    
    
    
    fileprivate func updateUI() {
        if arr_userData["social"]["facebook"].stringValue != ""{
            self.getFBUserData(forOld: true)
            view_fb.isHidden = true
        }
        if arr_userData["social"]["twitter"].stringValue != ""{
            view_tw.isHidden = true
        }
        if arr_userData["social"]["instagram"].stringValue != ""{
            view_ig.isHidden = true
        }
        if arr_userData["social"]["whatsapp"].stringValue != ""{
            view_wp.isHidden = true
        }
        if arr_userData["social"]["facebook"].stringValue != "" && arr_userData["social"]["twitter"].stringValue != "" && arr_userData["social"]["instagram"].stringValue != "" && arr_userData["social"]["whatsapp"].stringValue != ""{
            lbl_message.isHidden = false
            allAdded = true
        }
        
        print(arr_userData["trip"][0]["date"].stringValue)
        
        print(dateStringFromDate(date: Date(), format: "MM/dd/yyyy"))
        
        let expiryDate = arr_userData["trip"][0]["date"].stringValue
        var s : Date!
        if expiryDate != ""{
            if let dateString = formattedDateFromString(dateString: expiryDate, withFormat: "dd/MM/yyyy"){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                s = dateFormatter.date(from: dateString)!
            }
        }
        
        if allAdded{
            if fromMenu{
                lbl_message.isHidden = false
            }
            else{
                if s != nil && !compareDate(date1: Date(), date2: s){
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc: MapVC = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                    self.navigationController?.pushViewController(vc, animated: true)
                    return
                }
                self.btn_next.sendActions(for: .touchUpInside)
            }
        }
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.string(from: date)
        }

        return nil
    }
    
    func compareDate(date1:Date, date2:Date) -> Bool {
        let order = NSCalendar.current.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        case .orderedDescending:
            return true
        case .orderedAscending:
            return false
        default:
            return false
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getDetails()
        
        hideKeyboardWhenTappedAround()
        
        if fromMenu{
            addSlideMenuButton(header_view: view_header)
            btn_next.isHidden = true
        }
        else{
            btn_next.isHidden = false
        }
        
        let labels = getLabelsInView(view: view)
        
        for label in labels{
            if label.tag == 3{
                label.setDynamicRegularFont(fontsize: 12)
            }
        }
            
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAllInfoWindow))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"reloadSocialData"),
                                               object:nil, queue:nil,
                                               using:reloadSocialData)
        
    }
    
    func reloadSocialData(notification:Notification) -> Void {
        allAdded = false
        getDetails()
    }
    
    @objc func hideAllInfoWindow() {
        view_info.isHidden = true
    }
    
    @IBAction func action_info(_ sender: Any) {
        if view_info.isHidden {
            view_info.isHidden = false
        }
        else{
            view_info.isHidden = true
        }
    }
    
    @IBAction func action_insta(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PopUpVC = storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        vc.popUpFor = .instagram
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func action_wp(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: PopUpVC = storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
        vc.popUpFor = .whatsapp
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func action_fb(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
              // if user cancel the login
              if (result?.isCancelled)!{
                self.alert(message: "Facebook Login Is Cancelled By User")
//                      return
              }
              if(fbloginresult.grantedPermissions.contains("email"))
              {
                self.getFBUserData(forOld: false)
              }
            }
        }
    }
    
    @IBAction func action_twitter(_ sender: Any) {
    
        provider.getCredentialWith(nil) { credential, error in
          if error != nil {
            print(error?.localizedDescription as Any)
          }
          if credential != nil {
            Auth.auth().signIn(with: credential!) { authResult, error in
              if error == nil {
                print(authResult?.user.uid as Any)
                let userData : NSDictionary = (authResult?.additionalUserInfo?.profile!)! as NSDictionary
                self.sendPrivateData(showProgree: true, key: "twitter", value: "\(userData.value(forKey: "screen_name") ?? "")")
              }
                print(error?.localizedDescription as Any)
            }
            
          }
        }
    }
    
    @IBAction func action_next(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: AddTripVC = storyboard.instantiateViewController(withIdentifier: "AddTripVC") as! AddTripVC
        vc.hideBack = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getFBUserData(forOld: Bool){
        if forOld{
            showProgress("Fetching your facebook details")
        }
        if AccessToken.current == nil{
            dissmissProgress()
            return
        }
        let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            print(authError)
            return
          }
            print(authResult?.user.uid as Any)
            let userData : NSDictionary = (authResult?.additionalUserInfo?.profile!)! as NSDictionary
            print(userData)
            if((AccessToken.current) != nil){
                
                let requestMe = GraphRequest.init(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email, birthday, gender"])

                requestMe.start(completionHandler: {(connection, result, error) -> Void in
                    if (error == nil){
                        let reposnse = result as! NSDictionary
                        let jResponse = JSON(reposnse)
                        if !forOld{
                            self.sendPrivateData(showProgree: true, key: "facebook", value: "\(jResponse["id"])")
                        }
                        else{
                            self.dissmissProgress()
                            self.lbl_name.text = "\(jResponse["first_name"])"
                            self.img_user.sd_setImage(with: URL.init(string: "\(jResponse["picture"]["data"]["url"])"), completed: nil)
                            self.view_userData.isHidden = false
                        }
                    }
                    else{
                        print(error?.localizedDescription as Any)
                        self.dissmissProgress()
                    }
                })

            }
//            self.sendPrivateData(showProgree: true, key: "twitter", value: "\(userData.value(forKey: "screen_name") ?? "")")
        }
        
//        showProgress()
        
      }
}


extension SocialVC{
    
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
                                    let refreshAlert = UIAlertController(title: nil, message: json["message"].string!, preferredStyle: UIAlertController.Style.alert)
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                            self.getDetails()
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
                                self.updateUI()
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

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}

