//
//  MenuViewController.swift
//  SideMenuUsingXIB
//
//  Created by Jainish on 25/12/17.
//  Copyright © 2017 Assure live technology. All rights reserved.
//

import UIKit
import SwiftyJSON


protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int, section_selected: Int,titleText: String)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var btnCloseMenuOverlay: UIButton!
    @IBOutlet var tblMenuOptions: UITableView!
    
    @IBOutlet var img_user: UIImageView!
    
    @IBOutlet var lblRight: UILabel!
    @IBOutlet var sep_width_top_left: NSLayoutConstraint!
    @IBOutlet var sep_width_top_right: NSLayoutConstraint!
    @IBOutlet var sep_width: NSLayoutConstraint!
    @IBOutlet var lblLeft: UILabel!
    
    @IBOutlet var lblRightBottom: UILabel!
    @IBOutlet var lblLeftBottom: UILabel!
    
    @IBOutlet var lblName: UILabel!{
        didSet{
            lblName.setDynamicRegularFont(fontsize: 18)
        }
    }
    @IBOutlet var lblEmail: UILabel!{
        didSet{
            lblEmail.setDynamicRegularFont(fontsize: 11)
        }
    }
    
    @IBOutlet var header_view: UIView!
    @IBOutlet var blankHeaderView: UIView!
    
    var section_selected:Int = 0
    
    var is_execut = false
    
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCloseMenuOverlay.tintColor = UIColor.appColor(.mainColor)
        
        tblMenuOptions.tableFooterView = UIView()
        tblMenuOptions.showsVerticalScrollIndicator = false
        tblMenuOptions.showsHorizontalScrollIndicator = false
        
        tblMenuOptions.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cellMenu")
        tblMenuOptions.register(UINib(nibName: "SignOutCell", bundle: nil), forCellReuseIdentifier: "SignOutCell")
        tblMenuOptions.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "HeaderTableViewCell")
        
        
        lblName.text = "\(arr_userData["name"])"
        lblEmail.text = "\(arr_userData["country"])"
        
        
        view.layoutIfNeeded()
        view.updateConstraints()

        applyGradient(view: lblLeft, colours: [UIColor.appColor(.gray)!,UIColor.clear])
        applyGradient(view: lblRight, colours: [UIColor.clear,UIColor.appColor(.gray)!])
        
        applyGradient(view: lblLeftBottom, colours: [UIColor.appColor(.gray)!,UIColor.clear])
        applyGradient(view: lblRightBottom, colours: [UIColor.clear,UIColor.appColor(.gray)!])
        
        view.layoutIfNeeded()
        view.updateConstraints()

    }
    
    func getTodayString() -> String{
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy hh:mm a"
        let result = formatter.string(from: date)
        return result
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tblMenuOptions.reloadData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(!is_execut)
        {
            is_execut = true
            view.setNeedsLayout()
            view.layoutIfNeeded()
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1{
            return arr_bottom_menu.count
        }
        return arr_menu.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return iPad ? 60 : 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1{
            return blankHeaderView
        }
        return header_view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            return 20
        }
        return iPad ? 180 : 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellMenu", for: indexPath) as! TableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        if appDelegate.cur_index == indexPath.row && appDelegate.cur_section == indexPath.section{
            cell.lblTitle.textColor = UIColor.appColor(.mainColor)
            cell.img_icon_2.tintColor =  UIColor.appColor(.mainColor)
        }
        else{
            cell.lblTitle.textColor = .black
            cell.img_icon_2.tintColor =  .black
        }
        
        
        if indexPath.section == 0{
            cell.lblTitle.text = arr_menu[indexPath.row]["title"] as? String
            cell.img_icon_2.image = arr_menu[indexPath.row]["img_icon"] as? UIImage
        }
        else{
            cell.lblTitle.text = arr_bottom_menu[indexPath.row]["title"] as? String
            cell.img_icon_2.image = arr_bottom_menu[indexPath.row]["img_icon"] as? UIImage
        }
        
        
//        cell.img_icon_2.tintColor = UIColor.appColor(.mainColor)
        
        if indexPath.row == arr_menu.count - 1{
            cell.lbl_seprator.isHidden = true
        }
        else{
            cell.lbl_seprator.isHidden = false
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        appDelegate.cur_index = indexPath.row
        appDelegate.cur_section = indexPath.section

        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        btn.accessibilityValue = "\(indexPath.section)"
        section_selected = indexPath.row
        self.onCloseMenuClick(btn)
    }

    @IBAction func onCloseMenuClick(_ sender: UIButton) {
        
//        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = sender.tag
            let section = Int("\(sender.accessibilityValue ?? "0")")
//            if(sender == self.btnCloseMenuOverlay){
//                index = appDelegate.cur_index
//            }
            if(sender == self.btnCloseMenuOverlay){
                index = -1
            }
            else{
                if section == 0{
                    delegate?.slideMenuItemSelectedAtIndex(index,section_selected: section_selected,titleText: "\(arr_menu[appDelegate.cur_index]["title"]!)")
                }
                else if section == 1{
                    delegate?.slideMenuItemSelectedAtIndex(index,section_selected: section_selected,titleText: "\(arr_bottom_menu[appDelegate.cur_index]["title"]!)")
                }
            
            }
        }
        

        UIView.animate(withDuration: 0.1, animations: {
            self.btnCloseMenuOverlay.alpha = 0
        }) { (finished) in
            self.btnCloseMenuOverlay.isHidden = finished
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
                self.view.layoutIfNeeded()
                self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParent()
            })
        }
    }
    
    @objc func action_signout(sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
