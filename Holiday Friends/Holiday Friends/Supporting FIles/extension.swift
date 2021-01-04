//
//  Static Function.swift
//  Direct Bazaar
//
//  Created by Jainish on 02/12/17.
//  Copyright © 2017 Assure live technology. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import SwiftyJSON
import Alamofire
import MessageUI

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func bottom_border(view: UIView,color: UIColor, border_size: CGFloat)
    {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0.0, y: view.bounds.height-border_size, width: view.bounds.width, height: border_size)
        bottomBorder.backgroundColor = color.cgColor
        view.layer.addSublayer(bottomBorder)
    }
    
    func getCurrentSelectedLanguage() -> String{
        if UserDefaults.standard.string(forKey: "selectedLanguage") == "en"{
            return "en"
        }
        else if UserDefaults.standard.string(forKey: "selectedLanguage") == "ms-MY"{
            return "ms-MY"
        }
        else if UserDefaults.standard.string(forKey: "selectedLanguage") == "zh-Hant"{
            return "zh-Hant"
        }
        else{
            return ""
        }
    }
    
    func getTodayDateStringHome(_ date: Date) -> String{
        
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let day = components.day
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        let nameOfMonth = dateFormatter.string(from: date)
        
        let today_string = String(day!) + date.daySuffix() + " " + String(nameOfMonth) + " " + String(year!)
        
        return today_string
        
    }
    
    func getTodayDateString(_ date: Date) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: date)
        
    }
    
    func getTodayTimeString() -> String{
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let nameOfMonth = dateFormatter.string(from: date)
        
        let today_string = String(nameOfMonth)
        
        return today_string
        
    }
    
    func getDayStringFromDateString(dateString: String) -> String{
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //        dateFormatter.timeZone = TimeZone (abbreviation: "UTC")
        //dateFormatter.timeZone = NSTimeZone.local
        
        let date = dateFormatter.date(from: dateString)
        //        let calender = Calendar.current
        //        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date!)
        
        //        let year = components.year
        //        let day = components.day
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd-MM-yyyy"
        //        let nameOfMonth =
        return dateFormatter2.string(from: date!)
        //        let today_string = String(day!) + date!.daySuffix() + " " + String(nameOfMonth) + " " + String(year!)
        //
        //        return today_string
        
    }
    
    func dateStringFromCurrentDate() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        let myString = formatter.string(from: Date()) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    
    func dateStringRemoveZero() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date())
        return myString
    }
    
    func alert(message: String, title: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                                        switch action.style{
                                        case .default:
                                            print("default")
                                        case .cancel:
                                            print("cancel")
                                        case .destructive:
                                            print("destructive")
                                        @unknown default:
                                            print("Default")
                                        }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dateStringFromDate(date: Date,format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss a"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = format
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func dateFromString(date: String,_ dateFormat: String,_ outPutFormat: String) -> String{
        let dateString = date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let dateObj = dateFormatter.date(from: dateString)
        
        dateFormatter.dateFormat = outPutFormat
        
        return dateFormatter.string(from: dateObj!)
    }
    
    func popupAlertWithButton(actionTitles:[String?],actionMessage: String, actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: "Alert".getLocalizeLanguage(), message: actionMessage, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func setup_header(headerView: UIView, lblTitle: UILabel, lblBack: UILabel)
    {
        headerView.backgroundColor = UIColor.clear
        lblBack.backgroundColor = UIColor.appColor(.white)
        lblBack.text = ""
        lblTitle.textColor = UIColor.appColor(.black)
        //        lblTitle.font = UIFont.fontMedium(ofSize: CGFloat(header_font_size))
        
        for case let btn as UIButton in headerView.subviews {
            let image = btn.imageView?.image?.withRenderingMode(.alwaysTemplate)
            btn.setImage(image, for: .normal)
            btn.tintColor = UIColor.appColor(.black)
            btn.setTitleColor(UIColor.appColor(.black), for: .normal)
        }
    }
    
    func showProgress(_ message: String? = nil){
        if message != nil{
            SVProgressHUD.show(withStatus: message)
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        else{
            SVProgressHUD.show()
            SVProgressHUD.setDefaultMaskType(.clear)
        }
        
    }
    
    func dissmissProgress(){
        SVProgressHUD.dismiss()
    }
    
    func dateStringFromCurrentDateSeconds() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: Date()) // string purpose I add here
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "yyyy-MM-dd"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    func setDate() -> String{
        UserDefaults.standard.set(dateStringFromCurrentDateSeconds(), forKey: "currentDate")
        return UserDefaults.standard.object(forKey: "currentDate") as! String
    }
    
    func getDate() -> String{
        if (UserDefaults.standard.object(forKey: "currentDate") != nil){
            return UserDefaults.standard.object(forKey: "currentDate") as! String
        }
        else{
            return setDate()
        }
    }
    
    func checkDateChangedOrNot() -> Bool{
        if getDate() == dateStringFromCurrentDateSeconds(){
            return true
        }
        else{
            return false
        }
    }
    
    func getProfileData() -> JSON{
        
        if (UserDefaults.standard.object(forKey: "profile") != nil){
            //            return JSON(UserDefaults.standard.object(forKey: "subjectIds") as JSON.RawValue)
            var p = ""
            if let buildNumber = UserDefaults.standard.value(forKey: "profile") as? String {
                p = buildNumber
            }else {
                p = ""
            }
            if  p != "" {
                if let json = p.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                    return try! JSON(data: json)
                }
                setProfileData(arr: [])
                return []
            }
            setProfileData(arr: [])
            return []
        }
        setProfileData(arr: [])
        return []
    }
    
    func setProfileData(arr: JSON){
        arr_userData = arr
        UserDefaults.standard.set(arr.rawString(), forKey: "profile")
    }
    
    
    func getLabelsInView(view: UIView) -> [UILabel] {
        var results = [UILabel]()
        for subview in view.subviews as [UIView] {
            if let labelView = subview as? UILabel {
                results += [labelView]
            } else {
                results += getLabelsInView(view: subview)
            }
        }
        return results
    }
    func getTextfieldsInView(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textfieldView = subview as? UITextField {
                results += [textfieldView]
            } else {
                results += getTextfieldsInView(view: subview)
            }
        }
        return results
    }
    
    func dropShadow(viewfor: UIView, color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        viewfor.layer.masksToBounds = false
        viewfor.layer.shadowColor = color.cgColor
        viewfor.layer.shadowOpacity = opacity
        viewfor.layer.shadowOffset = offSet
        viewfor.layer.shadowRadius = radius
    }
    
    func applyGradientSep(view: UIView,colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func applyGradient(view: UIView,colours: [UIColor]) -> Void {
        self.applyGradient(view: view,colours:colours, locations: nil)
    }
    
    func applyGradient(view: UIView,colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.endPoint = CGPoint(x:0.0, y:1.0)
        gradient.startPoint = CGPoint(x:1.0, y:1.0)
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradientTopBottom(view: UIView,colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func UIDeviceModel() -> String {
        
        let modelName: String = {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            
            func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
                #if os(iOS)
                switch identifier {
                case "iPod5,1":                                 return "iPod Touch 5"
                case "iPod7,1":                                 return "iPod Touch 6"
                case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
                case "iPhone4,1":                               return "iPhone 4s"
                case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
                case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
                case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
                case "iPhone7,2":                               return "iPhone 6"
                case "iPhone7,1":                               return "iPhone 6 Plus"
                case "iPhone8,1":                               return "iPhone 6s"
                case "iPhone8,2":                               return "iPhone 6s Plus"
                case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
                case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
                case "iPhone8,4":                               return "iPhone SE"
                case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
                case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
                case "iPhone10,3", "iPhone10,6":                return "iPhone X"
                case "iPhone11,2":                              return "iPhone XS"
                case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
                case "iPhone11,8":                              return "iPhone XR"
                case "iPhone12,1":                              return "iPhone 11"
                case "iPhone12,3":                              return "iPhone 11 Pro"
                case "iPhone12,5":                              return "iPhone 11 Pro Max"
                case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
                case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
                case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
                case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
                case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
                case "iPad6,11", "iPad6,12":                    return "iPad 5"
                case "iPad7,5", "iPad7,6":                      return "iPad 6"
                case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
                case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
                case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
                case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
                case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
                case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
                case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
                case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
                case "AppleTV5,3":                              return "Apple TV"
                case "AppleTV6,2":                              return "Apple TV 4K"
                case "AudioAccessory1,1":                       return "HomePod"
                case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
                default:                                        return identifier
                }
                #elseif os(tvOS)
                switch identifier {
                case "AppleTV5,3": return "Apple TV 4"
                case "AppleTV6,2": return "Apple TV 4K"
                case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
                default: return identifier
                }
                #endif
            }
            
            return mapToDevice(identifier: identifier)
        }()
        
        return modelName
        
    }
    
    func addDevice()
    {
        if Reachability.isConnectedToNetwork()
        {
            let params  = [
                "user_id" : arr_userData["id"].stringValue,
                "device_type" : "iPhone",
                "app_version" : appVersion!,
                "device_model" : device_name,
                "os_version" : systemVersion,
                "device_id" : device_udid,
                "device_token" : device_token
            ] as [String : String]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr_selectedActivitiesIds, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print(jsonString!)
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
                },
                to: "\(api_addDevice)",
                headers: Auth_header,
                encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.dissmissProgress()
                            if let value = response.result.value {
                                let json = JSON(value)
                                print(json)
                            }
                        }
                    case .failure( _): break
                        
                    }
                }
            )
            
        }
    }
    
    func sendTwitterMessage(screenName : String){
        //        let screenName =  "NJMINISTRIESINC"
        let appURL = URL(string: "twitter://user?screen_name=\(screenName)")!
        let webURL = URL(string: "https://twitter.com/\(screenName)")!
        
        if UIApplication.shared.canOpenURL(appURL as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL)
            } else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            //redirect to safari because the user doesn't have Instagram
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(webURL)
            } else {
                UIApplication.shared.openURL(webURL)
            }
        }
    }
    
    func openWhatsApp(phoneNumber: String){
        var appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
        if UIApplication.shared.canOpenURL(appURL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
            }
            else {
                UIApplication.shared.openURL(appURL)
            }
        } else {
            appURL = URL(string: "https://wa.me/\(phoneNumber)")!
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
        }
    }
    
    func openInstagram(id : String){
        if let url = URL(string: "instagram://user?username=\(id)") {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in
                
                if success == false {
                    // Messenger is not installed. Open in browser instead.
                    let url = URL(string: "http://instagram.com/\(id)")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.open(url!)
                    }
                }
            })
        }
        
    }
    
    func openFB(id: String){
//        id = "2391998227749801"
//        fb-messenger://user-thread/\(id)
//        fb://profile?app_scoped_user_id=2015414535261745
        
//        if UIApplication.shared.canOpenURL(URL(string: "fb://profile/2015414535261745")!) {
//            UIApplication.shared.open(URL(string: "fb://profile/2015414535261745")!, options: [:])
//        } else {
//            UIApplication.shared.open(URL(string: "https://facebook.com/2015414535261745")!, options: [:])
//        }
        
        if let url = URL(string: "fb://profile/\(id)") {
            UIApplication.shared.open(url, options: [:], completionHandler: {
                (success) in

                if success == false {
                    // Messenger is not installed. Open in browser instead.
                    let url = URL(string: "fb://profile/\(id)")
                    if UIApplication.shared.canOpenURL(url!) {
                        UIApplication.shared.open(url!)
                    }
                }
            })
        }
    }
    
    func sendMail(recipientEmail: String){
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([recipientEmail])
            mail.setSubject("Bored Abroad")
            mail.setMessageBody("", isHTML: false)
            
            present(mail, animated: true)
            
            // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: "Bored Abroad", body: "") {
            UIApplication.shared.open(emailUrl)
        }
    }
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    
}


class GradientTabBarController: UITabBarController {
    
    let gradientlayer = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.white
        setGradientBackground(colorOne: UIColor.appColor(.gradiantStart)!, colorTwo: UIColor.appColor(.gradiantEnd)!)
    }
    
    func setGradientBackground(colorOne: UIColor, colorTwo: UIColor)  {
        gradientlayer.frame = tabBar.bounds
        gradientlayer.colors = [colorOne.cgColor, colorTwo.cgColor]
        gradientlayer.locations = [0, 1]
        gradientlayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientlayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        self.tabBar.layer.insertSublayer(gradientlayer, at: 0)
    }
}

extension UICollectionViewDelegate{
    
    func dropShadow(viewfor: UIView, color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        viewfor.layer.masksToBounds = false
        viewfor.layer.shadowColor = color.cgColor
        viewfor.layer.shadowOpacity = opacity
        viewfor.layer.shadowOffset = offSet
        viewfor.layer.shadowRadius = radius
    }
    
}

extension UITableViewCell{
    func getDayStringFromDateString(dateString: String) -> String{
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        let date = dateFormatter.date(from: dateString)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd-MM-yyyy"
        return dateFormatter2.string(from: date!)
        
    }
}

extension String{
    
    func getLocalizeLanguage() -> String{
        if UserDefaults.standard.string(forKey: "selectedLanguage") == "en"{
            let path = Bundle.main.path(forResource: "en", ofType: "lproj")
            let bundal = Bundle.init(path: path!)! as Bundle
            return bundal.localizedString(forKey: self, value: nil, table: nil)
        }
        else if UserDefaults.standard.string(forKey: "selectedLanguage") == "ms-MY"{
            let path = Bundle.main.path(forResource: "ms-MY", ofType: "lproj")
            let bundal = Bundle.init(path: path!)! as Bundle
            return bundal.localizedString(forKey: self, value: nil, table: nil)
        }
        else if UserDefaults.standard.string(forKey: "selectedLanguage") == "zh-Hant"{
            let path = Bundle.main.path(forResource: "zh-Hant", ofType: "lproj")
            let bundal = Bundle.init(path: path!)! as Bundle
            return bundal.localizedString(forKey: self, value: nil, table: nil)
        }
        else{
            return ""
        }
    }
    
    func trim() -> String {
        return self.replacingOccurrences(of: "\r\n\r\n", with: "\r\n", options: .regularExpression)
    }
    
    func checkStringdata() -> Bool
    {
        let result = self.trimmingCharacters(in: .whitespacesAndNewlines)
        if result != ""
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func validatePhonenumber() -> Bool {
        if(self.count != 10)
        {
            return false
        }
        return true
    }
    
}

extension UIView{
    func setFullRadius()
    {
        self.layer.cornerRadius = self.layer.frame.size.height/2
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func setRadius(_ radius : CGFloat)
    {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func setBorder(border_value : CGFloat, color: UIColor){
        self.layer.borderWidth = border_value
        self.layer.borderColor = color.cgColor
        self.layer.masksToBounds = true
    }
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
    
    func shadowRadius(radius: CGFloat) {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.0
    }
    
    
    
    func addShadow(shadowColor: UIColor, offSet: CGSize, opacity: Float, shadowRadius: CGFloat, cornerRadius: CGFloat, corners: UIRectCorner, fillColor: UIColor = .white) {
        
        let shadowLayer = CAShapeLayer()
        let size = CGSize(width: cornerRadius, height: cornerRadius)
        let cgPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: size).cgPath //1
        shadowLayer.path = cgPath //2
        shadowLayer.fillColor = fillColor.cgColor //3
        shadowLayer.shadowColor = shadowColor.cgColor //4
        shadowLayer.shadowPath = cgPath
        shadowLayer.shadowOffset = offSet //5
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        shadowLayer.accessibilityLabel = "shadow"
        self.layer.addSublayer(shadowLayer)
    }
    
}

extension UITextField{
    
    func setDynamicRegularFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.font = UIFont.init(name: font_regular, size: FinalFortSize)
    }
    
    func setDynamicBoldFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.font = UIFont.init(name: font_bold, size: FinalFortSize)
    }
    
    func changePlaceholderColor(color: UIColor){
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!,
                                                        attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
}

class PaddingTextField: UITextField {
    
    @IBInspectable var paddingLeft: CGFloat = 0
    @IBInspectable var paddingRight: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: bounds.origin.x + paddingLeft, y: bounds.origin.y, width: bounds.size.width - paddingLeft - paddingRight, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}



extension UIButton{
    
    func setDynamicRegularFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.titleLabel?.font = UIFont.init(name: font_regular, size: FinalFortSize)!
    }
    
    func setDynamicBoldFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.titleLabel?.font = UIFont.init(name: font_bold, size: FinalFortSize)!
    }
    
}



extension UITextView{
    
    func setDynamicRegularFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.font = UIFont.init(name: font_regular, size: FinalFortSize)
    }
    
    func setDynamicBoldFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.font = UIFont.init(name: font_bold, size: FinalFortSize)
    }
    
}

extension UILabel{
    func setDynamicRegularFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.font = UIFont.init(name: font_regular, size: FinalFortSize)
    }
    func setDynamicBoldFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.font = UIFont.init(name: font_bold, size: FinalFortSize)
    }
    
    func setDynamicMediumFont(fontsize : Float)
    {
        let FinalFortSize = ((screenWidth * CGFloat(fontsize)) / 320)
        self.font = UIFont.init(name: font_medium, size: FinalFortSize)
    }
    
    func setRegularFont(fontsize : Float)
    {
        self.font = UIFont.init(name: font_regular, size: CGFloat(fontsize))
    }
    func setBoldFont(fontsize : Float)
    {
        self.font = UIFont.init(name: font_bold, size: CGFloat(fontsize))
    }
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}


class RoundedButtonWithShadow: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height/2
        self.layer.shadowColor = UIColor.appColor(.gray)?.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 2.0
    }
}


class RadiusView: UIView {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10
    }
}


extension Notification.Name {
    static let changeLanguage = Notification.Name("changeLanguage")
    static let reloadQuote = Notification.Name("reloadQuote")
    static let reloadHomeData = Notification.Name("reloadHomeData")
    static let moveToHome = Notification.Name("moveToHome")
    static let reloadProfile = Notification.Name("reloadProfile")
    static let moveToStudentList = Notification.Name("moveToStudentList")
    static let twitterCallback = Notification.Name(rawValue: "Twitter.CallbackNotification.Name")
    static let selectCountry = Notification.Name("selectCountry")
    
}

extension UIFont {
    
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        let font = UIFont(name: name, size: size)
        assert(font != nil, "Can't load font: \(name)")
        return font ?? UIFont.systemFont(ofSize: size)
    }
    
    static func fontRegular(ofSize size: CGFloat) -> UIFont {
        let FinalFontSize = ((screenWidth * CGFloat(size)) / 320)
        return customFont(name: font_regular, size: FinalFontSize)
    }
    
    
}

extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
    func daySuffix() -> String {
        let calendar = Calendar.current
        let dayOfMonth = calendar.component(.day, from: self)
        switch dayOfMonth {
        case 1, 21, 31: return "st"
        case 2, 22: return "nd"
        case 3, 23: return "rd"
        default: return "th"
        }
    }
    
}

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
            { _ in completion() }
    }
    func reloadDataWithAutoSizingCellWorkAround() {
        self.reloadData()
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.reloadData()
    }
}

extension Float {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.0f", self)
    }
}

extension Notification.Name {
    static let reloadAttendanceData = Notification.Name("reloadAttendanceData")
    static let reloadHomeworkData = Notification.Name("reloadHomeworkData")
    static let reloadCircularData = Notification.Name("reloadCircularData")
    static let reloadEventsData = Notification.Name("reloadEventsData")
    static let reloadRemarkData = Notification.Name("reloadRemarkData")
    static let reloadDailyQuotes = Notification.Name("reloadDailyQuotes")
    static let reloadNotesList = Notification.Name("reloadNotesList")
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}
