//
//  AppDelegate.swift
//  Y Mart
//
//  Created by Keyur Kankotiya on 05/08/20.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
import FirebaseMessaging
import SwiftyJSON
import SDWebImageSVGCoder
import FirebaseCore

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var cur_index = 3
    var cur_section = 0
    
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let SVGCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(SVGCoder)
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
          }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        device_token = GetDeviceToken("")
        
        GMSPlacesClient.provideAPIKey(googleMapKey)

        IQKeyboardManager.shared.enable = true
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().backgroundColor = .white
        
        GMSServices.provideAPIKey(googleMapKey)
        
        return true
    }
    
    
    func GetDeviceToken(_ token : String) -> String
    {
        if let checkdevicetoken = UserDefaults.standard.string(forKey: "device_token")
        {
            if checkdevicetoken == ""{
                UserDefaults.standard.set(token, forKey: "device_token")
            }
            UIPasteboard.general.string = checkdevicetoken
            return checkdevicetoken
        }
        else
        {
            UserDefaults.standard.set(token, forKey: "device_token")
            return token
        }
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
            
        }
      }
        
    }
  
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }

    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        print(url)
        return true
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("Device Token: \(token)")
    
    }
    
    func application(
      _ application: UIApplication,
      didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
      print("Failed to register: \(error)")
    }
    
    func application(
      _ application: UIApplication,
      didReceiveRemoteNotification userInfo: [AnyHashable: Any],
      fetchCompletionHandler completionHandler:
      @escaping (UIBackgroundFetchResult) -> Void
    ) {
//      guard let aps = userInfo["aps"] as? [String: AnyObject] else {
//        completionHandler(.failed)
//        return
//      }
//        print(aps)
      print(userInfo)
    }
    
    
}

@available(iOS 10, *)
extension AppDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        _ = notification.request.content.userInfo
        print(notification.request.content.userInfo)
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        print("willPresent notification")
        
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        let jsonString = userInfo["data"] as! String
        print("[\(jsonString)]")
        var jsonObj : JSON = []
        if let json = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            jsonObj =  try! JSON(data: json)
        }
        redirectToNotiScreen(obj: jsonObj)
        print(jsonObj)
        completionHandler()
    }
//
    func redirectToNotiScreen(obj: JSON) {
//        switch appDelegate.notiFor {
//        case 1:
//            appDelegate.notiFor = 0
//            if currently_active == "HomeWorkVC"{
//                NotificationCenter.default.post(name: .reloadHomeworkData, object: nil, userInfo: nil)
//            }
//            else{
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UserProfileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
        vc.arr_user = obj
        vc.fromNoti = true
        if let navigationController = self.window?.rootViewController as? UINavigationController
        {
            navigationController.present(vc, animated: true, completion: nil)
        }
        else
        {
            print("Navigation Controller not Found")
        }
                
//            }
//            break
//        case 2:
//            appDelegate.notiFor = 0
//            if currently_active == "DailyAttendanceVC"{
//                NotificationCenter.default.post(name: .reloadAttendanceData, object: nil, userInfo: nil)
//            }
//            else{
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: DailyAttendanceVC = storyboard.instantiateViewController(withIdentifier: "DailyAttendanceVC") as! DailyAttendanceVC
//                vc.from_noti = true
//                self.navController?.pushViewController(vc, animated: true)
//            }
//            break
//        case 3:
//            appDelegate.notiFor = 0
//            if currently_active == "CircularNotesVC"{
//                NotificationCenter.default.post(name: .reloadCircularData, object: nil, userInfo: nil)
//            }
//            else{
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: CircularNotesVC = storyboard.instantiateViewController(withIdentifier: "CircularNotesVC") as! CircularNotesVC
//                vc.from_noti = true
//                self.navController?.pushViewController(vc, animated: true)
//            }
//            break
//        case 4:
//            appDelegate.notiFor = 0
//            if currently_active == "TeachersRemarkVC"{
//                NotificationCenter.default.post(name: .reloadRemarkData, object: nil, userInfo: nil)
//            }
//            else{
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: TeachersRemarkVC = storyboard.instantiateViewController(withIdentifier: "TeachersRemarkVC") as! TeachersRemarkVC
//                vc.from_noti = true
//                self.navController?.pushViewController(vc, animated: true)
//            }
//            break
//        case 5:
//            appDelegate.notiFor = 0
//            if currently_active == "EventVC"{
//                NotificationCenter.default.post(name: .reloadEventsData, object: nil, userInfo: nil)
//            }
//            else{
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: EventVC = storyboard.instantiateViewController(withIdentifier: "EventVC") as! EventVC
//                vc.from_noti = true
//                self.navController?.pushViewController(vc, animated: true)
//            }
//            break
//        case 6:
//            appDelegate.notiFor = 0
//            if currently_active == "Quotes"{
//                NotificationCenter.default.post(name: .reloadDailyQuotes, object: nil, userInfo: nil)
//            }
//            else{
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: DailyQuotesVC = storyboard.instantiateViewController(withIdentifier: "DailyQuotesVC") as! DailyQuotesVC
//                vc.from_noti = true
//                self.navController?.pushViewController(vc, animated: true)
//            }
//            break
//        case 7:
//            appDelegate.notiFor = 0
//            if currently_active == "Notes"{
//                NotificationCenter.default.post(name: .reloadNotesList, object: nil, userInfo: nil)
//            }
//            else{
//                let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc: NotesListVC = storyboard.instantiateViewController(withIdentifier: "NotesListVC") as! NotesListVC
//                vc.from_noti = true
//                self.navController?.pushViewController(vc, animated: true)
//            }
//            break
//        default:
//            print("No NOtification FOUND")
//        }
    }
}
// [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        device_token = GetDeviceToken(fcmToken)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("didReceive remoteMessage")
//        print("Received data message: \(remoteMessage.appData[AnyHashable("alert")] ?? "")")
    }
}
