//
//  AddTripVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 28/08/20.
//

import UIKit
import FSCalendar
import SwiftyJSON
import Alamofire
import GooglePlacesSearchController
import GooglePlaces

class AddTripVC: BaseViewController, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var coll_month: UICollectionView!{
        didSet{
            coll_month.register(UINib(nibName: "MonthCell", bundle: nil), forCellWithReuseIdentifier: "MonthCell")
        }
    }
    @IBOutlet weak var coll_year: UICollectionView!{
        didSet{
            coll_year.register(UINib(nibName: "MonthCell", bundle: nil), forCellWithReuseIdentifier: "MonthCell")
        }
    }
    
    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var txt_title: UITextField!{
        didSet{
            txt_title.setDynamicRegularFont(fontsize: 30)
        }
    }
    
    
    @IBOutlet weak var txt_date: UITextField!
    @IBOutlet weak var txt_activity: UITextField!
    @IBOutlet weak var txt_place: UITextField!
    
    @IBOutlet weak var btn_back: UIButton!
    
    @IBOutlet weak var btn_next: UIButton!
    @IBOutlet weak var btn_previous: UIButton!
    
    @IBOutlet weak var btn_public: UIButton!{
        didSet{
            btn_public.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    
    @IBOutlet weak var btn_private: UIButton!{
        didSet{
            btn_private.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    
    @IBOutlet weak var btn_onHoliday: UIButton!{
        didSet{
            btn_onHoliday.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    
    @IBOutlet weak var btn_migratetoAbroad: UIButton!{
        didSet{
            btn_migratetoAbroad.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    var forUpdate = false
    
    var arr_activities : JSON = []
    
    var arr_months : JSON = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ]
    
    var arr_years : JSON = [
        "2020", "2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"
    ]
    
    @IBOutlet weak var view_month: UIView!
    
    @IBOutlet weak var view_infoHowLong: UIView!
    @IBOutlet weak var view_location: UIView!
    @IBOutlet weak var view_privacy: UIView!
    @IBOutlet weak var view_activities: UIView!
    
    @IBOutlet weak var lbl_infoHowLong: UILabel!{
        didSet{
            lbl_infoHowLong.setDynamicRegularFont(fontsize: 12)
        }
    }
    @IBOutlet weak var lbl_location: UILabel!{
        didSet{
            lbl_location.setDynamicRegularFont(fontsize: 12)
        }
    }
    @IBOutlet weak var lbl_privacy: UILabel!{
        didSet{
            lbl_privacy.setDynamicRegularFont(fontsize: 12)
        }
    }
    @IBOutlet weak var lbl_activities: UILabel!{
        didSet{
            lbl_activities.setDynamicRegularFont(fontsize: 12)
        }
    }
    
    @IBOutlet weak var cal_trip: FSCalendar!
    
    @IBOutlet weak var constraint_bottom: NSLayoutConstraint!
    
    @IBOutlet weak var view_header: UIView!
    
    var hideBack = false
    
    var latitude = 0.0
    var longitude = 0.0
    var privacy = "public"
    var tripType = "holiday"
    var activities = ""
    var city = ""
    var state = ""
    var country = ""
    var userID = ""
    var dateTravel = ""
    
    var curYearIndex = 0
    var curMonthIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        hideKeyboardWhenTappedAround()
        
        cal_trip.dataSource = self
        cal_trip.delegate = self
        
        constraint_bottom.constant = 1000
        
        cal_trip.appearance.headerTitleColor = .white
            
        let date = Date()
        curMonthIndex = Int(date.month)! - 1
        
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
                label.textColor = .white
            }
        }
        
        for textfield in textFields{
            textfield.changePlaceholderColor(color: UIColor.appColor(.gray)!)
        }
        
        if forUpdate{
            lbl_header.text = "Update Activities"
        }
        
        if hideBack{
            btn_back.isHidden = true
            addSlideMenuButton(header_view: view_header)
        }
        else{
            btn_back.isHidden = false
        }

        txt_title.changePlaceholderColor(color: UIColor.white)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAllInfoWindow))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        getActivities()
        
        addDevice()
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"reason_activitySelect"),
                                               object:nil, queue:nil,
                                               using:reasonEndDateSelected)
        
    }
    
    func reasonEndDateSelected(notification:Notification) -> Void {
        txt_activity.text = arr_selectedActivities.componentsJoined(by: ", ")
    }
    
    @objc func hideAllInfoWindow() {
        view_infoHowLong.isHidden = true
        view_location.isHidden = true
        view_privacy.isHidden = true
        view_activities.isHidden = true
    }
    
    @IBAction func action_public(_ sender: Any) {
        self.view.endEditing(true)
        privacy = "public"
        btn_public.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        btn_private.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
    }
    
    @IBAction func action_private(_ sender: Any) {
        self.view.endEditing(true)
        privacy = "private"
        btn_private.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        btn_public.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
    }
    
    
    @IBAction func action_calOpen(_ sender: Any) {
        self.view.endEditing(true)
        constraint_bottom.constant = 30
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func dissmissCalendar() {
        constraint_bottom.constant = 1000
        UIView.animate(withDuration: 0.4) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func action_back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_howLong(_ sender: Any) {
        if view_infoHowLong.isHidden {
            view_infoHowLong.isHidden = false
            view_location.isHidden = true
            view_privacy.isHidden = true
            view_activities.isHidden = true
        }
        else{
            view_infoHowLong.isHidden = true
            view_location.isHidden = true
            view_privacy.isHidden = true
            view_activities.isHidden = true
        }
    }
    
    @IBAction func action_location(_ sender: Any) {
        if view_location.isHidden {
            view_location.isHidden = false
            view_infoHowLong.isHidden = true
            view_privacy.isHidden = true
            view_activities.isHidden = true
        }
        else{
            view_infoHowLong.isHidden = true
            view_location.isHidden = true
            view_privacy.isHidden = true
            view_activities.isHidden = true
        }
    }
    
    @IBAction func action_locationOfTrip(_ sender: Any) {
        txt_place.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func action_next(_ sender: Any) {
        curYearIndex = curYearIndex + 1
        if curYearIndex == arr_years.count - 1{
            btn_next.isHidden = true
        }
        else{
            btn_previous.isHidden = false
        }
        txt_date.text = "\(arr_months[curMonthIndex]), \(arr_years[curYearIndex])"
        coll_year.scrollToItem(at: IndexPath.init(row: curYearIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    @IBAction func action_previous(_ sender: Any) {
        curYearIndex = curYearIndex - 1
        if curYearIndex == 0{
            btn_previous.isHidden = true
        }
        else{
            btn_next.isHidden = false
        }
        txt_date.text = "\(arr_months[curMonthIndex]), \(arr_years[curYearIndex])"
        dateTravel = txt_date.text!
        coll_year.scrollToItem(at: IndexPath.init(row: curYearIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    
    @IBAction func action_privacy(_ sender: Any) {
        if view_privacy.isHidden {
            view_privacy.isHidden = false
            view_infoHowLong.isHidden = true
            view_location.isHidden = true
            view_activities.isHidden = true
        }
        else{
            view_infoHowLong.isHidden = true
            view_location.isHidden = true
            view_privacy.isHidden = true
            view_activities.isHidden = true
        }
    }
    
    @IBAction func action_activitiesInfo(_ sender: Any) {
        if view_activities.isHidden {
            view_activities.isHidden = false
            view_infoHowLong.isHidden = true
            view_location.isHidden = true
            view_privacy.isHidden = true
        }
        else{
            view_infoHowLong.isHidden = true
            view_location.isHidden = true
            view_privacy.isHidden = true
            view_activities.isHidden = true
        }
    }
    
    @IBAction func action_calClose(_ sender: Any) {
        dissmissCalendar()
    }
    
    @IBAction func action_onHoliday(_ sender: Any) {
        view_month.isHidden = true
        cal_trip.isHidden = false
        tripType = "holiday"
        btn_onHoliday.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        btn_migratetoAbroad.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
    }
    
    @IBAction func action_migrateToAbroad(_ sender: Any) {
        view_month.isHidden = false
        cal_trip.isHidden = true
        tripType = "migrate"
        btn_migratetoAbroad.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        btn_onHoliday.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
    }
    
    @IBAction func action_calChooseDate(_ sender: Any) {
        dissmissCalendar()
    }
    
    @IBAction func action_activities(_ sender: Any) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: ChildActivityVC = storyboard.instantiateViewController(withIdentifier: "ChildActivityVC") as! ChildActivityVC
        vc.arr_activities = arr_activities
        if #available(iOS 13.0, *) {
            vc.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        txt_date.text = dateStringFromDate(date: date, format: "dd-MM-YYYY")
        dateTravel = dateStringFromDate(date: date, format: "MM/dd/YYYY")
    }
    
    @IBAction func action_submit(_ sender: Any) {
        if txt_title.text?.count == 0{
            alert(message: "Please enter Trip Title")
        }
        else if dateTravel == ""{
            alert(message: "Please select Date")
        }
        else if txt_place.text?.count == 0{
            alert(message: "Please select Location of trip")
        }
        else if txt_activity.text?.count == 0{
            alert(message: "Please select activity")
        }
        else{
            addTrip()
        }
        
    }
    
    
    func getActivities()
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: api_activityList)!
            self.showProgress()
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { response in
                switch response.result {
                case .success:
                    self.dissmissProgress()
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let json = JSON(value)
                            if json["type"].stringValue == "success"{
                                self.arr_activities = json["data"]
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
                            self.getActivities()
                        }, nil])
                }
            }
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
                },{action2 in
                    self.getActivities()
                }, nil])
        }
    }
    
    
    func addTrip()
    {
        if Reachability.isConnectedToNetwork()
        {
            self.showProgress()
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr_selectedActivitiesIds, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print(jsonString!)
            
            let params    = [
                "title" : txt_title.text!,
                "date"    :    dateTravel,
                "type"      :    tripType,
                "latitude"      :    latitude,
                "longitude"      :    longitude,
                "privacy"      :    privacy,
                "activity"      :    jsonString!,
                "city"      :    city,
                "state"      :    state,
                "country"      :    country,
                "userid"      :    arr_userData["id"].stringValue] as [String : Any]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
            },
                to: "\(api_addTrip)",
                headers: Auth_header,
                encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.dissmissProgress()
                            if let value = response.result.value {
                                let json = JSON(value)
                                if "\(json["status"])" != "200"
                                {
                                    self.alert(message: json["message"].string!)
                                }
                                else
                                {
                                    let refreshAlert = UIAlertController(title: nil, message: "Trip added successfully", preferredStyle: UIAlertController.Style.alert)
                                        
                                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                        let vc: MapVC = storyboard.instantiateViewController(withIdentifier: "MapVC") as! MapVC
                                        vc.fromMenu = false
                                        self.navigationController?.pushViewController(vc, animated: true)
                                                }))
                                        self.present(refreshAlert, animated: true, completion: nil)
                                }
                            }
                            
                            
                            
                        }
                    case .failure( _):
                        self.dissmissProgress()
                        self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                            
                            },{action2 in
                                self.addTrip()
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
                    self.addTrip()
                }, nil])
        }
    }
    
}

extension AddTripVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == coll_year{
            return arr_years.count
        }
        return arr_months.count
    }
    
    
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            if collectionView == coll_year{
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            }
            return CGSize(width: collectionView.bounds.width/4, height: collectionView.bounds.height/3)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as? MonthCell else {
            return UICollectionViewCell()
        }
        
        if collectionView == coll_year{
            cell.lbl_title.text = "\(arr_years[indexPath.row])"
            cell.lbl_title.textColor = UIColor.appColor(.mainColor)
        }
        else{
            
            if indexPath.row == curMonthIndex{
                cell.lbl_title.textColor = UIColor.appColor(.mainColor)
            }
            else{
                cell.lbl_title.textColor = .white
            }
            
            cell.lbl_title.text = "\(arr_months[indexPath.row])"
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == coll_month{
            curMonthIndex = indexPath.row
            txt_date.text = "\(arr_months[curMonthIndex]), \(arr_years[curYearIndex])"
            dateTravel = txt_date.text!
            coll_month.reloadData()
        }
    }
    
}
extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        return dateFormatter.string(from: self)
    }
}

extension AddTripVC: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        txt_place.text = place.name
        country = place.addressComponents?.first(where: { $0.type == "country" })!.name ?? ""
        city = place.addressComponents?.first(where: { $0.type == "administrative_area_level_2" })!.name ?? ""
        state = place.addressComponents?.first(where: { $0.type == "administrative_area_level_1" })!.name ?? ""
        latitude = place.coordinate.latitude
        longitude = place.coordinate.longitude
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
