//
//  BaseViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import SwiftyJSON

class BaseViewController: UIViewController, SlideMenuDelegate {
    let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"MENU_OPEN"),
                                               object:nil, queue:nil,
                                               using:action_openMenu)
        // Do any additional setup after loading the view.
    }
    
    func action_openMenu(notification:Notification) -> Void {
        onSlideMenuButtonPressed(btnShowMenu)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func slideMenuItemSelectedAtIndex(_ index: Int, section_selected: Int, titleText: String) {
        if titleText == "Home"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: MapVC = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
            vc.fromMenu = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "My Tripes"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: AllTripsVC = storyboard.instantiateViewController(withIdentifier: "AllTripsVC") as! AllTripsVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "Update Activities"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: AddTripVC = storyboard.instantiateViewController(withIdentifier: "AddTripVC") as! AddTripVC
            vc.forUpdate = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "Social Connections"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: SocialVC = storyboard.instantiateViewController(withIdentifier: "SocialVC") as! SocialVC
            vc.fromMenu = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "Add New Trip"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: AddTripVC = storyboard.instantiateViewController(withIdentifier: "AddTripVC") as! AddTripVC
            vc.hideBack = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "How It Works"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: TermsVC = storyboard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            vc.header_text = titleText
            vc.text = howItWorks
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "Terms Of Use"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: TermsVC = storyboard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            vc.header_text = titleText
            vc.text = terms
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if titleText == "Privacy Policy"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: TermsVC = storyboard.instantiateViewController(withIdentifier: "TermsVC") as! TermsVC
            vc.header_text = titleText
            vc.text = privacy
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "Settings"{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: SettingVC = storyboard.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if titleText == "Logout"{
            funcLogout()
        }
        
    }
    
    func addSlideMenuButton(header_view: UIView){
        btnShowMenu.tintColor = UIColor.black
        btnShowMenu.setImage(UIImage.init(named: "menu"), for: UIControl.State())
        btnShowMenu.frame = CGRect(x: 20,y: header_view.frame.height - 44, width: 44, height: 44)
        btnShowMenu.tintColor = UIColor.appColor(.mainColor)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        header_view.addSubview(btnShowMenu)
    }
    
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        if (sender.tag == 3)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectedAtIndex(-1,section_selected: -1,titleText: "");
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : MenuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuVC.btnMenu = sender
        menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:{(finished: Bool) in
            UIView.transition(with: menuVC.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                menuVC.btnCloseMenuOverlay.isHidden = false
            })
        })
        
    }
}


extension BaseViewController{
    
    func funcLogout()
    {
        let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in 
            self.setProfileData(arr: [])
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    func logoutFromDevice() -> Void {
//        if Reachability.isConnectedToNetwork()
//        {
//            self.showProgress()
//            let url = URL(string: api_logout)!
//
//            let Auth_header    = [ "Auth-Key" : authKey,
//                                   "Client-Service" : clientservice,
//                                   "Content-Type" : contenttype]
//
//            let studentid = UserDefaults.standard.string(forKey: "id")
//            let deviceToken = UserDefaults.standard.string(forKey: "device_token")
//
//            let params: [String: String] = ["student_id": studentid!,
//                                            "device_token": deviceToken!]
//
//            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
//                switch response.result {
//                case .success:
//                    self.dissmissProgress()
//                    if let value = response.result.value {
//                        let json = JSON(value)
//                        if json["type"] == "sucess"
//                        {
//                            UserDefaults.standard.removeObject(forKey: "token")
//                            UserDefaults.standard.removeObject(forKey: "id")
//                            self.navigationController?.popViewController(animated: true)
//                        }
//                        else
//                        {
//                            self.alert(message: json["message"].string!)
//                        }
//                    }
//                case .failure(let error):
//                    self.dissmissProgress()
//                    self.popupAlertWithButton(actionTitles: [self.getLocalizeLanguage(strText: titleTryAgain),self.getLocalizeLanguage(strText: titleOk)], actionMessage: titleServiceProblem, actions: [{action1 in
//                        self.logoutFromDevice()
//                        },{action2 in
//
//                        }, nil])
//                    print("RESPONSE ERROR: \(error)")
//                }
//            }
//
//        }
//        else
//        {
//            self.dissmissProgress()
//            self.popupAlertWithButton(actionTitles: [self.getLocalizeLanguage(strText: titleTryAgain),self.getLocalizeLanguage(strText: titleOk)], actionMessage: titleNetworkNotAvailable, actions: [{action1 in
//                self.logoutFromDevice()
//                },{action2 in
//
//                }, nil])
//        }
    }
    
}
