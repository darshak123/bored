//
//  MapVC.swift
//  Holiday Friends
//
//  Created by Keyur Kankotiya on 07/09/20.
//

import UIKit
import SwiftyJSON
import GoogleMaps
import SDWebImage
import Alamofire
import GoogleMapsUtils
import MessageUI

class MapVC: BaseViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    
    let TWITTER_CONSUMER_KEY = "iyEIaViKcnCh0jwwKPo21k20t"
    let TWITTER_CONSUMER_SECRET = "QPt7elne6lWkOLbUvUawYmuBghAImr9uGDxH94mb9mOT4jEa4U"
    let TWITTER_URL_SCHEME = "twittersdk"
    
    let kMapStyle = "[\r\n  {\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#f5f5f5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.icon\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#616161\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"elementType\": \"labels.text.stroke\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#f5f5f5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.land_parcel\",\r\n    \"elementType\": \"labels\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"administrative.land_parcel\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#bdbdbd\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#eeeeee\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"labels.text\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#757575\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi.business\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi.park\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#e5e5e5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"poi.park\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#ffffff\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road\",\r\n    \"elementType\": \"labels.icon\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.arterial\",\r\n    \"elementType\": \"labels\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.arterial\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#757575\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#dadada\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"elementType\": \"labels\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.highway\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#616161\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.local\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.local\",\r\n    \"elementType\": \"labels\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"road.local\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit\",\r\n    \"stylers\": [\r\n      {\r\n        \"visibility\": \"off\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit.line\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#e5e5e5\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"transit.station\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#eeeeee\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"water\",\r\n    \"elementType\": \"geometry\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#c9c9c9\"\r\n      }\r\n    ]\r\n  },\r\n  {\r\n    \"featureType\": \"water\",\r\n    \"elementType\": \"labels.text.fill\",\r\n    \"stylers\": [\r\n      {\r\n        \"color\": \"#9e9e9e\"\r\n      }\r\n    ]\r\n  }\r\n]\r\n"
    
    let allMarkersPosition : NSMutableArray = []
    let allMarkersImages : NSMutableDictionary = [:]
    
    
    var arr_users : JSON = []

    
    @IBOutlet weak var mapView: GMSMapView!
    private var clusterManager: GMUClusterManager!
    
    @IBOutlet weak var btn_wp: UIButton!
    @IBOutlet weak var btn_ig: UIButton!
    @IBOutlet weak var btn_mail: UIButton!
    @IBOutlet weak var btn_twitter: UIButton!
    @IBOutlet weak var btn_fb: UIButton!
    
    @IBOutlet weak var constrain_bottom: NSLayoutConstraint!
    @IBOutlet weak var btnUserProfile: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var lbl_name: UILabel!{
        didSet{
            lbl_name.setDynamicBoldFont(fontsize: 20)
        }
    }
    @IBOutlet weak var lbl_city: UILabel!{
        didSet{
            lbl_city.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var lbl_activities: UILabel!{
        didSet{
            lbl_activities.setDynamicRegularFont(fontsize: 14)
        }
    }
    
    @IBOutlet weak var txt_search: PaddingTextField!{
        didSet{
            txt_search.setDynamicRegularFont(fontsize: 14)
        }
    }
    @IBOutlet weak var img_user: UIImageView!
    
    @IBOutlet weak var btn_addTrip: UIButton!
    
    @IBOutlet weak var view_header: UIView!
    
    //    private var clusterManager: GMUClusterManager!
    
    let locationManager = CLLocationManager.init()
    
    var fromMenu = false
    
    var lastLocation = false
    
    var currentUser = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        
        appDelegate.cur_index = 0
        
        addSlideMenuButton(header_view: view_header)
        
        let iconGenerator = GMUDefaultClusterIconGenerator()
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)
        
        // Register self to listen to GMSMapViewDelegate events.
        clusterManager.setMapDelegate(self)
        
//        clusterManager.cluster()
        
        if fromMenu {
            btn_addTrip.isHidden = false
        }
        else{
            btn_addTrip.isHidden = true
        }
        
        do {
            // Set the map style by passing a valid JSON string.
            mapView.mapStyle = try GMSMapStyle(jsonString: kMapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        mapView.setMinZoom(1, maxZoom: 13)
        
        txt_search.changePlaceholderColor(color: UIColor.appColor(.gray)!)
        allTrips(lat: "21.23357967111166", lng: "72.86295699292589")
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        if CLLocationManager.locationServicesEnabled() {
          switch (CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
              print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
              print("Access")
          @unknown default:
            print("default")
          }
        } else {
          print("Location services are not enabled")
        }
        
    }
    
    //Location Manager delegates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        
        if !lastLocation{

            print(locations.last?.coordinate.latitude as Any)
            print(locations.last?.coordinate.longitude as Any)
            
//            let camera = GMSCameraPosition.camera(withLatitude: (locations.last?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!, zoom: 15.0)
//
//            self.mapView?.animate(to: camera)
            
//            if arr_users.count == 0 {
//                allTrips(lat: "\(locations.last?.coordinate.latitude ?? 0.0)", lng: "\(locations.last?.coordinate.longitude ?? 0.0)")
//            }
            
            lastLocation = true
            
        }
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func loadUsers(){
        var index = 0
        
        let camera = GMSCameraPosition.camera(withLatitude: arr_users[0]["latitude"].doubleValue, longitude: arr_users[0]["longitude"].doubleValue, zoom: 6)
        mapView?.camera = camera
        mapView?.animate(to: camera)
        
        for user in arr_users{
            let _: GMSMarker = GMSMarker() // Allocating Marker

            let str = user.1["user"]["image"][0]["thumb"].stringValue
            var icon = URL.init(string: "")
            if str != ""{
                icon = URL.init(string: str)!
            }
            else{
                icon = URL.init(string: defaultAvatar)!
            }

//            var imgData = try? Data(contentsOf: icon!)
            //       marker.iconView = CustomMarkerView(forUrl: url)
//            if imgData == nil{
//                icon = URL.init(string: defaultAvatar)!
//                imgData = try? Data(contentsOf: icon!)
//            }

//            marker.icon = self.drawImageWithProfilePic(pp: UIImage.init(data:imgData!)!, image: UIImage.init(named: "unselected")!)
//             marker.appearAnimation = .pop // Appearing animation. default
//            marker.position = CLLocationCoordinate2D.init(latitude: user.1["latitude"].doubleValue, longitude: user.1["longitude"].doubleValue) // CLLocationCoordinate2D
            
//            applyImage(from: icon!, to: marker)


//            print("\(index),\(user.1["user"]["image"][0]["thumb"].stringValue)")
            
            generateClusterItems(lat:  user.1["latitude"].stringValue, lng:  user.1["longitude"].stringValue, img: icon!, index: "\(index)")
                    
            index = index + 1
            
        }

    }
    
    func applyImage(from url: URL, to marker: GMSMarker, index userIndex: String) {
        DispatchQueue.global(qos: .background).async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)?.cropped()
                else { return }

            DispatchQueue.main.async { [self] in
                allMarkersImages.setValue(self.drawImageWithProfilePic(pp: image, image: UIImage.init(named: "unselected")!), forKey: userIndex)
                marker.icon = self.drawImageWithProfilePic(pp: image, image: UIImage.init(named: "unselected")!)
            }
        }
    }
    
    func allTrips(lat: String, lng: String)
    {
        if Reachability.isConnectedToNetwork()
        {
            let url = URL(string: api_trips)!
            self.showProgress()
            
            //            let Auth_header    = [ "Auth-Key" : "simplerestapi",
            //                                   "Client-Service"    :    "frontend-client",
            //                                   "Content-Type"      :    "application/json"]
            
            Alamofire.request(url, method: .get, parameters: ["lat": lat,"long": lng], encoding: URLEncoding.default, headers: Auth_header).validate(statusCode: 200..<600).responseJSON() { [self] response in
                switch response.result {
                case .success:
                    self.dissmissProgress()
                    if response.result.value != nil {
                        if let value = response.result.value {
                            let json = JSON(value)
                            if json["type"].stringValue == "success"{
                                arr_users = json["data"]
                                if arr_users.count > 0{
                                    self.loadUsers()
                                }
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
                        self.allTrips(lat: lat, lng: lng)
                    }, nil])
                }
            }
            
        }
        else
        {
            self.dissmissProgress()
            self.popupAlertWithButton(actionTitles: ["Ok","Try Again"], actionMessage: "Internet Connection is not Available!!!", actions: [{action1 in
                
            },{action2 in
                self.allTrips(lat: lat, lng: lng)
            }, nil])
        }
    }
    
    func drawImageWithProfilePic(pp: UIImage, image: UIImage) -> UIImage {
        
        let imgView = UIImageView(image: image)
        imgView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imgView.tintColor = UIColor.appColor(.mainColor)
        
        let picImgView = UIImageView(image: pp)
        picImgView.frame = CGRect(x: 3, y: 3, width: 54, height: 54)
        
        imgView.addSubview(picImgView)
        picImgView.center.x = imgView.center.x
        picImgView.center.y = imgView.center.y
        picImgView.layer.cornerRadius = picImgView.frame.width/2
        picImgView.clipsToBounds = true
        imgView.setNeedsLayout()
        picImgView.setNeedsLayout()
        
        let newImage = imageWithView(view: imgView)
        return newImage
    }
    
    func imageWithView(view: UIView) -> UIImage {
        var image: UIImage?
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image ?? UIImage()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.animate(toLocation: marker.position)
        if let _ = marker.userData as? GMUCluster {
            mapView.animate(toZoom: mapView.camera.zoom + 1)
            NSLog("Did tap cluster")
            return true
        }
        btn_addTrip.isHidden = true
        constrain_bottom.constant = 20
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        currentUser = Int(marker.accessibilityValue!) ?? 0
        if arr_users[currentUser]["user"]["image"][0].count > 0{
            img_user.sd_setImage(with: URL.init(string: arr_users[currentUser]["user"]["image"][0]["thumb"].stringValue), completed: nil)
        }
        else{
            img_user.sd_setImage(with: URL.init(string: defaultAvatar), completed: nil)
        }
        
        if arr_users[currentUser]["user"]["social"]["facebook"].stringValue != ""{
            btn_fb.isEnabled = true
            btn_fb.alpha = 1
        }
        else{
            btn_fb.alpha = 0.2
        }
        if arr_users[currentUser]["user"]["social"]["twitter"].stringValue != ""{
            btn_twitter.isEnabled = true
            btn_twitter.alpha = 1
        }
        else{
            btn_twitter.alpha = 0.2
        }
        if arr_users[currentUser]["user"]["social"]["instagram"].stringValue != ""{
            btn_ig.isEnabled = true
            btn_ig.alpha = 1
        }
        else{
            btn_ig.alpha = 0.2
        }
        if arr_users[currentUser]["user"]["social"]["whatsapp"].stringValue != ""{
            btn_wp.isEnabled = true
            btn_wp.alpha = 1
        }
        else{
            btn_wp.alpha = 0.2
        }
        
        lbl_name.text = arr_users[currentUser]["user"]["name"].stringValue
        lbl_activities.text = getAllActivities(arrActivities: arr_users[currentUser]["activity"])
        btnUserProfile.tag = currentUser
        self.mapView?.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 15.0)
        return true
    }
    
    func getAllActivities(arrActivities: JSON) -> String{
        var str_activities = ""
        for activity in arrActivities{
            for child_activity in activity.1["child"]{
                if str_activities == ""{
                    str_activities = child_activity.1["name"].stringValue
                }
                else{
                    str_activities = "\(str_activities), \(child_activity.1["name"])"
                }
            }
        }
        return str_activities
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        constrain_bottom.constant = -1000
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        
        if fromMenu {
            btn_addTrip.isHidden = false
        }
        else{
            btn_addTrip.isHidden = true
        }
    }
    
    @IBAction func action_userProfile(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UserProfileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        vc.arr_user = arr_users[sender.tag]["user"]
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func action_addTrip(_ sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: AddTripVC = storyboard.instantiateViewController(withIdentifier: "AddTripVC") as! AddTripVC
        vc.hideBack = false
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    private func generateClusterItems(lat: String, lng: String,img: URL, index: String) {
        guard let lat = Double(lat) else { return  }
        guard let lng = Double(lng) else { return  }
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        let item = ClusterItem(position: position, image: img, userIndex: index, img: UIImage.init() )
        clusterManager.add(item)
        
    }
    
    @IBAction func action_wp(_ sender: Any) {
        let phoneNumber = arr_users[currentUser]["user"]["social"]["whatsapp"].stringValue
        openWhatsApp(phoneNumber: phoneNumber)
    }
    
    @IBAction func action_ig(_ sender: Any) {
        let id = arr_users[currentUser]["user"]["social"]["instagram"].stringValue
        openInstagram(id: id)
    }
    
    @IBAction func action_tw(_ sender: Any) {
        sendTwitterMessage(screenName: arr_users[currentUser]["user"]["social"]["twitter"].stringValue)
    }
    
    @IBAction func action_mail(_ sender: Any) {
        let recipientEmail = arr_users[currentUser]["user"]["email"].stringValue
        sendMail(recipientEmail: recipientEmail)
    }
    
    @IBAction func action_fb(_ sender: Any) {
        let id = arr_users[currentUser]["user"]["social"]["facebook"].stringValue
        openFB(id: id)
    }
    
    
    
    
}


class ClusterItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var image : URL
    var userIndex : String
    var img : UIImage
    init(position: CLLocationCoordinate2D, image: URL?, userIndex: String?, img: UIImage) {
        self.position = position
        self.image = image!
        self.userIndex = userIndex!
        self.img = img
    }
}

extension MapVC: GMUClusterManagerDelegate,GMUClusterRendererDelegate {
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        if  let markerData = (marker.userData as? ClusterItem) {
            marker.accessibilityValue = markerData.userIndex
            if markerData.img.size.width != 0.0{
                marker.icon = markerData.img
                return
            }
            if allMarkersImages.value(forKey: markerData.userIndex) != nil{
                marker.icon = allMarkersImages.value(forKey: markerData.userIndex) as? UIImage
                markerData.img = (allMarkersImages.value(forKey: markerData.userIndex) as? UIImage)!
                return
            }
            else{
                applyImage(from: markerData.image, to: marker, index: markerData.userIndex)
            }
            allMarkersPosition.add(markerData.userIndex)
        }
        
        
    }
}

extension UIImage {

    func cropped() -> UIImage? {
//        let cropRect = CGRect(x: 0, y: 0, width: 44 * scale, height: 44 * scale)

        guard let croppedCGImage = cgImage else { return nil }

        return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
    }
}
