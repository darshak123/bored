//
//  SingleSelectionVC.swift
//  Corona Response
//
//  Created by KD Kankotiya on 03/04/20.
//  Copyright © 2020 KD Kankotiya. All rights reserved.
//

import UIKit
import SwiftyJSON

class SingleSelectionVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet var btn_done: UIButton!
    @IBOutlet var btn_cancel: UIButton!
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var height_search: NSLayoutConstraint!
    
    @IBOutlet var lbl_title: UILabel!{
        didSet{
            lbl_title.setDynamicBoldFont(fontsize: 18)
        }
    }
    
    @IBOutlet var tbl_data: UITableView!{
        didSet{
            tbl_data.register(UINib(nibName: "SelectionCell", bundle: nil), forCellReuseIdentifier: "SelectionCell")
        }
    }
    
    var array_display : JSON = []
    var array_filter : JSON = []
    
    var cur_value = ""
    var tbl_title = ""
    
    var searchEnable = false
    var isSearch = false
    
    var notiName : NSNotification.Name = NSNotification.Name(rawValue: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btn_done.setDynamicRegularFont(fontsize: 15)
        btn_cancel.setDynamicRegularFont(fontsize: 15)
        
        lbl_title.text = tbl_title
        
        if searchEnable{
            height_search.constant = 60
        }
        else{
            height_search.constant = 0
        }
        
        array_filter = array_display
        
        self.searchBar.delegate = self
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField

        textFieldInsideSearchBar?.textColor = .white
    }
    
    @IBAction func action_cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count == 0 {
            isSearch = false;
            self.tbl_data.reloadData()
        } else {
            
            let arrTemp : NSArray = array_display.arrayObject! as NSArray
            let predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText);
            array_filter = []
            array_filter = JSON(arrTemp.filtered(using: predicate))
            
            if(array_filter.count == 0){
                isSearch = false;
            } else {
                isSearch = true;
            }
            self.tbl_data.reloadData()
        }
    }
    
}


extension SingleSelectionVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch{
            return array_filter.count
        }
        return array_display.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let lbl = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 10))
        lbl.backgroundColor = .clear
        return lbl
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SelectionCell! = tableView.dequeueReusableCell(withIdentifier: SelectionCell.className, for:indexPath)as? SelectionCell
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        if isSearch{
            cell.lbl_title.text = "\(array_filter[indexPath.row]["name"])"
            let svgURL = URL(string: "\(array_filter[indexPath.row]["flag"])")!
            
            cell.img_country.sd_setImage(with: svgURL)
            
            if cur_value == array_filter[indexPath.row]["name"].stringValue{
                cell.lbl_title.setDynamicBoldFont(fontsize: 15)
            }
            else{
                cell.lbl_title.setDynamicRegularFont(fontsize: 15)
            }
            
            if indexPath.row == array_filter.count-1{
                cell.lbl_sep.isHidden = true
            }
            else{
                cell.lbl_sep.isHidden = false
            }
        }
        else{
            cell.lbl_title.text = "\(array_display[indexPath.row]["name"])"
            let svgURL = URL(string: "\(array_display[indexPath.row]["flag"])")!
            
            cell.img_country.sd_setImage(with: svgURL)
            
            if cur_value == array_display[indexPath.row]["name"].stringValue{
                cell.lbl_title.setDynamicBoldFont(fontsize: 15)
            }
            else{
                cell.lbl_title.setDynamicRegularFont(fontsize: 15)
            }
            
            if indexPath.row == array_display.count-1{
                cell.lbl_sep.isHidden = true
            }
            else{
                cell.lbl_sep.isHidden = false
            }
        }
        
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearch{
            NotificationCenter.default.post(name:notiName,
                                            object: nil,
                                            userInfo: [
                                                "c_code":array_filter[indexPath.row]["callingCodes"][0].stringValue,
                                                "img":array_filter[indexPath.row]["flag"].stringValue,
                                                "country":array_filter[indexPath.row]["name"].stringValue])
            
        }
        else{
            NotificationCenter.default.post(name:notiName,
                                            object: nil,
                                            userInfo: ["c_code":array_filter[indexPath.row]["callingCodes"][0].stringValue,"img":array_filter[indexPath.row]["flag"].stringValue,
                                                       "country":array_filter[indexPath.row]["name"].stringValue])
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}
