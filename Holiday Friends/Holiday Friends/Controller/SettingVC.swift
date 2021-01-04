//
//  AddTripVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 28/08/20.
//

import UIKit
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth
import Firebase

class SettingVC: BaseViewController {
    
    
    var imagePicker = UIImagePickerController()
    var imgData : Data!
    
    var provider = OAuthProvider(providerID: "twitter.com")
    
    @IBOutlet weak var coll_images: UICollectionView!{
        didSet{
            coll_images.register(UINib(nibName: "ProfileCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var img_user: UIImageView!
    
    @IBOutlet weak var txt_fb: UITextField!
    @IBOutlet weak var txt_tw: UITextField!
    @IBOutlet weak var txt_ig: UITextField!
    
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var txt_phone: UITextField!
    @IBOutlet weak var txt_country: UITextField!
    
    @IBOutlet weak var img_editDone: UIImageView!
    @IBOutlet weak var lbl_header: UILabel!{
        didSet{
            lbl_header.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var btn_public: UIButton!{
        didSet{
            btn_public.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var btn_uploadImage: UIButton!
    
    @IBOutlet weak var constrain_height: NSLayoutConstraint!
    
    @IBOutlet weak var btn_private: UIButton!{
        didSet{
            btn_private.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var view_header: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        
        getDetails()
        
        addSlideMenuButton(header_view: view_header)
        
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
        
        changeTextfieldMode(false)
        
        updateUI()
        
        
        NotificationCenter.default.addObserver(forName:Notification.Name(rawValue:"reloadSocialData"),
                                               object:nil, queue:nil,
                                               using:reloadSocialData)
        
        NotificationCenter.default.addObserver(self, selector: #selector(action_countrySelect(notification:)), name: .selectCountry, object: nil)
        
    }
    
    
    @objc func action_countrySelect(notification:Notification) -> Void {
        let userData = notification.userInfo! as NSDictionary
        print(userData)
        selected_Country = userData.value(forKey: "country") as! String
        selected_CountryCode = userData.value(forKey: "c_code") as! String
        txt_country.text = selected_Country
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
    
    
    func reloadSocialData(notification:Notification) -> Void {
        getDetails()
    }
    
    func changeTextfieldMode(_ forUpdate: Bool){
        
        let textFields = getTextfieldsInView(view: view)
        
        for textfield in textFields{
            if forUpdate {
                btn_public.isEnabled = true
                btn_private.isEnabled = true
                if textfield.tag != 1{
                    textfield.isEnabled = true
                }
                btn_uploadImage.isEnabled = true
            }
            else{
                btn_public.isEnabled = false
                btn_private.isEnabled = false
                textfield.isEnabled = false
                btn_uploadImage.isEnabled = false
            }
            
        }
    }
    
    
    func getFBUserData(){
        showProgress()
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                let reposnse = result as! NSDictionary
                self.sendPrivateData(showProgree: true, key: "facebook", value: "\(reposnse["id"] ?? "")")
            }
            else{
                self.dissmissProgress()
            }
          })
        }
      }
    
    fileprivate func updateUI() {
        
        if arr_userData["image"].count > 0{
            img_user.sd_setImage(with: URL.init(string: "\(arr_userData["image"][0]["thumb"])"), completed: nil)
            constrain_height.constant = 90
        }
        else{
            img_user.sd_setImage(with: URL.init(string: defaultAvatar), completed: nil)
            constrain_height.constant = 0
        }
        
        txt_name.text = "\(arr_userData["name"])"
        txt_email.text = "\(arr_userData["email"])"
        txt_password.text = "Admin@1234"
        txt_phone.text = "\(arr_userData["mobile"])"
        txt_country.text = "\(arr_userData["country"])"
        
        if arr_userData["social"]["facebook"].stringValue != ""{
            txt_fb.text = "Connected"
        }
        else{
            txt_fb.text = "Connect"
        }
        if arr_userData["social"]["twitter"].stringValue != ""{
            txt_tw.text = "Connected"
        }
        else{
            txt_tw.text = "Connect"
        }
        if arr_userData["social"]["instagram"].stringValue != ""{
            txt_ig.text = "Connected"
        }
        else{
            txt_ig.text = "Connect"
        }
        
        coll_images.reloadData()
    }
    
}

//MARK: Image Upload
extension SettingVC : UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBAction func action_uploadfile(_ sender: Any) {
        
        let myController = UIAlertController(title: nil, message: "Select Image From", preferredStyle: UIAlertController.Style.actionSheet)
        if iPad {
            myController.popoverPresentationController?.sourceView = sender as? UIView
            myController.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
        }
        myController.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { action in
            self.fromGallery()
        }))
        myController.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { action in
            self.fromCamera()
        }))
        myController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        
        if arr_userData["image"].count == arr_userData["maximage"].intValue{
            alert(message: "You have uploaded maximum images!!!")
        }
        else{
            present(myController, animated: true, completion: nil)
        }
        
    }
    
    func fromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.modalPresentationStyle = .fullScreen
            present(imagePicker,animated: true,completion: nil)
        } else {
            //            noCamera()
            alert(message: "Camera not found")
        }
    }
    
    func fromGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage{
            imgData = chosenImage.jpegData(compressionQuality: 1)
            img_user.isHidden = false
            uploadProfile()
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    @objc func action_removeFile(_ sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete your profile?", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.funcRemoveImg(url: arr_userData["image"][sender.tag]["orignal"].stringValue)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func funcRemoveImg(url: String)
    {
        removeImage(urlPhoto: url)
    }
    
}

//MARK: Collection Delegate
extension SettingVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_userData["image"].count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - 30,height: collectionView.frame.height - 30)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30,left: 16,bottom: 0,right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coll_images.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! ProfileCell
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        cell.img_user.sd_setImage(with: URL.init(string: "\(arr_userData["image"][indexPath.row]["thumb"])"), completed: nil)
        
        cell.btn_delete.tag = indexPath.row
        cell.btn_delete.addTarget(self, action: #selector(action_removeFile(_:)), for: .touchUpInside)
        
        if img_editDone.isHighlighted {
            cell.btn_delete.isHidden = false
        }
        else{
            cell.btn_delete.isHidden = true
        }
        
        cell.img_user.setRadius(30)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
    }
    
}

//MARK: Actions
extension SettingVC{
    
    @IBAction func action_logout(_ sender: Any) {
        
            let refreshAlert = UIAlertController(title: "Logout", message: "Are you sure you want to Logout?", preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                self.setProfileData(arr: [])
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            
            present(refreshAlert, animated: true, completion: nil)
            
        
        
    }
    
    @IBAction func action_updateDone(_ sender: Any) {
        if img_editDone.isHighlighted{
            img_editDone.isHighlighted = false
            changeTextfieldMode(false)
            updateUser()
        }
        else{
            img_editDone.isHighlighted = true
            changeTextfieldMode(true)
            coll_images.reloadData()
        }
    }
    
    @IBAction func action_public(_ sender: Any) {
        btn_public.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        btn_private.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
    }
    
    @IBAction func action_private(_ sender: Any) {
        btn_private.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        btn_public.setImage(#imageLiteral(resourceName: "unselected"), for: .normal)
    }
    
    @IBAction func action_ig(_ sender: Any) {
        if arr_userData["social"]["instagram"].stringValue != ""{
            self.popupAlertWithButton(actionTitles: ["Yes","No"], actionMessage: "Are you sure you want to disconnect instagram?", actions: [{action1 in
                self.disconnectAccount(showProgree: true, key: "instagram")
            },{action2 in
                
            }, nil])
        }
        else{
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc: PopUpVC = storyboard.instantiateViewController(withIdentifier: "PopUpVC") as! PopUpVC
            vc.popUpFor = .instagram
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func action_tw(_ sender: Any) {
        if arr_userData["social"]["twitter"].stringValue != ""{
            self.popupAlertWithButton(actionTitles: ["Yes","No"], actionMessage: "Are you sure you want to disconnect twitter?", actions: [{action1 in
                self.disconnectAccount(showProgree: true, key: "twitter")
            },{action2 in
                
            }, nil])
        }
        else{
            provider.getCredentialWith(nil) { credential, error in
              if error != nil {
                print(error?.localizedDescription as Any)
              }
              if credential != nil {
                Auth.auth().signIn(with: credential!) { authResult, error in
                  if error == nil {
                    let userData : NSDictionary = (authResult?.additionalUserInfo?.profile!)! as NSDictionary
                    self.sendPrivateData(showProgree: true, key: "twitter", value: "\(userData.value(forKey: "screen_name") ?? "")")
                  }
                    print(error?.localizedDescription as Any)
                }
                
              }
            }
        }
    }
    
    
    @IBAction func action_fb(_ sender: Any) {
        if arr_userData["social"]["facebook"].stringValue != ""{
            self.popupAlertWithButton(actionTitles: ["Yes","No"], actionMessage: "Are you sure you want to disconnect facebook?", actions: [{action1 in
                self.disconnectAccount(showProgree: true, key: "facebook")
            },{action2 in
                
            }, nil])
            
        }
        else{
            let fbLoginManager : LoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
                if (error == nil){
                    let fbloginresult : LoginManagerLoginResult = result!
                  // if user cancel the login
                  if (result?.isCancelled)!{
                          return
                  }
                  if(fbloginresult.grantedPermissions.contains("email"))
                  {
                    self.getFBUserData()
                  }
                }
            }
        }
    }
    
}

//MARK: Network Call
extension SettingVC{
    
    
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
                                arr_userData = json["data"]
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
    
    func removeImage(urlPhoto: String)
    {
        if Reachability.isConnectedToNetwork()
        {
            self.showProgress()
            
            let params: [String: String] = ["userid" : "\(arr_userData["id"])","url" : urlPhoto]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
            },
                to: "\(api_removeImage)",
                headers: Auth_header,
                encodingCompletion: { encodingResult in
                    
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            self.dissmissProgress()
                            if let value = response.result.value {
                                let json = JSON(value)
                                if "\(json["status"])" == "200"
                                {
                                    self.getDetails()
                                }
                                else
                                {
                                    self.alert(message: json["message"].string!)
                                }
                            }
                            
                            
                            
                        }
                    case .failure( _):
                        self.dissmissProgress()
                        self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                            
                            },{action2 in
                                self.removeImage(urlPhoto: urlPhoto)
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
                    self.removeImage(urlPhoto: urlPhoto)
                }, nil])
        }
    }
    
    func uploadProfile()
    {
        if Reachability.isConnectedToNetwork()
        {
            self.showProgress()
            
            let params: [String: String] = [
                "userid": "\(arr_userData["id"])"]
            
            
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if self.imgData != nil{
                        multipartFormData.append(self.imgData, withName: "url[]", fileName: "image.jpg", mimeType: "image/jpeg")
                    }
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
            },
                to: "\(api_uploadImage)",
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
                                    self.getDetails()
                                }
                            }
                            
                            
                            
                        }
                    case .failure( _):
                        self.dissmissProgress()
                        self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                            
                            },{action2 in
                                self.uploadProfile()
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
                    self.uploadProfile()
                }, nil])
        }
    }
    
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
    
    
    func disconnectAccount(showProgree: Bool, key: String){
        if Reachability.isConnectedToNetwork()
        {
            self.showProgress()
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr_selectedActivitiesIds, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print(jsonString!)
            
            let params    = ["user_id" : "\(arr_userData["id"])", "key" : "\(key)"] as [String : Any]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
            },
                to: "\(api_disconnect)",
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
                                self.disconnectAccount(showProgree: showProgree, key: key)
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
                    self.disconnectAccount(showProgree: showProgree, key: key)
                }, nil])
        }
    }
    
    
    func updateUser()
    {
        if Reachability.isConnectedToNetwork()
        {
            self.showProgress()
            
            let jsonData = try? JSONSerialization.data(withJSONObject: arr_selectedActivitiesIds, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print(jsonString!)
            
            let params    = ["name":txt_name.text!,"email": txt_email.text!,"country": txt_country.text!, "mobile": txt_phone.text!] as [String : Any]
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    for (key, value) in params {
                        multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                    }
                    
            },
                to: "\(api_signUp)/\(arr_userData["id"])",
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
                                    self.popupAlertWithButton(actionTitles: ["Ok"], actionMessage: json["message"].stringValue, actions: [{action1 in
                                        self.setProfileData(arr: json["data"])
                                        self.updateUI()
                                    }, nil])
                                }
                            }
                            
                            
                            
                        }
                    case .failure( _):
                        self.dissmissProgress()
                        self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Something went wrong, please try again...", actions: [{action1 in
                            
                            },{action2 in
                                self.updateUser()
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
                    self.updateUser()
                }, nil])
        }
    }
}
