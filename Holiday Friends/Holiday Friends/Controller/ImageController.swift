//
//  ImageController.swift
//  HD Car Wallpapers
//
//  Created by Keyur Kankotiya on 01/06/19.
//  Copyright © 2019 Keyur Kankotiya. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class ImageController: UIViewController {

    @IBOutlet weak var coll_Images: UICollectionView!{
        didSet{
            self.coll_Images.register(UINib(nibName: "SingleImageCell", bundle: nil), forCellWithReuseIdentifier: "SingleImageCell")
            self.coll_Images.dataSource = self
            self.coll_Images.delegate = self
        }
    }
    
    var timer = Timer()
    
    var fromNoti = false
    
    @IBOutlet weak var btn_back: UIButton!
    
    @IBOutlet var img_background: UIImageView!
    @IBOutlet var img_loader: UIImageView!
    
    var session : URLSession!
    
    var userCancelDownload = false
    
    var indexNumber = 0
    var arr_images : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.coll_Images.reloadData()
        self.coll_Images.isHidden = true
        self.coll_Images.performBatchUpdates(nil, completion: {
            (result) in
            self.coll_Images.scrollToItem(at: IndexPath.init(item: self.indexNumber, section: 0), at: .centeredHorizontally, animated: false)
            self.coll_Images.isHidden = false
        })
        
        img_loader.setRadius(8)
        
        dropShadow(viewfor: btn_back, color: UIColor.appColor(.background)!, opacity: 1, offSet: CGSize.init(width: 0, height: 0), radius: 0, scale: true)
        
        if fromNoti{
            btn_back.setImage(UIImage.init(named: "cancel"), for: .normal)
        }
        
        
        
//        img_loader.loadGif(name: "loader")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    @IBAction func action_download(_ sender: UIButton) {
        downloadImageFromURL(url: URL.init(string: "\(arr_images[indexNumber]["orignal"].stringValue )")!)
    }
    
    @IBAction func action_back(_ sender: Any) {
        if fromNoti{
            self.dismiss(animated: true, completion: nil)
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func action_share(_ sender: UIButton) {

        if img_background.image != nil{
            let imageToShare = [ img_background.image ]
            let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash        // exclude some activity types from the list (optional)
            //        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop ]        // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }

    
    func hideProgressHudOnUserTap(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.tapToDismiss(notification:)), name: NSNotification.Name.SVProgressHUDDidReceiveTouchEvent, object: nil)
    }
    
    func disableHideProgressHudOnUserTap(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.SVProgressHUDDidReceiveTouchEvent, object: nil)
    }
    
    @objc func tapToDismiss(notification: Notification) {
        dissmissProgress()
        stopDownloading()
    }
    
    func removeProgressHudObserver(){
        stopDownloading()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.SVProgressHUDDidReceiveTouchEvent, object: nil)
    }
    
    func downloadImageFromURL(url: URL) {
        SVProgressHUD.show()
        hideProgressHudOnUserTap()
        let config = URLSessionConfiguration.default
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        session.downloadTask(with: url).resume()
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func stopDownloading(){
        session.invalidateAndCancel()
        disableHideProgressHudOnUserTap()
    }
    
}

//MARK: - Collection Mehod
extension ImageController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr_images.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: screenWidth,height: screenHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if appDelegate.isPortrait{
//            return UIEdgeInsets(top: 2,left: 2,bottom: 2,right: 2)
//        }
        return UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SingleImageCell.className, for: indexPath as IndexPath) as! SingleImageCell
        
        if arr_images[indexPath.row]["orignal"].stringValue != ""{
            cell.img_main.sd_setImage(with: URL(string: arr_images[indexPath.row]["orignal"].stringValue)) { (img, error, cacheType, url) in
                self.img_background.image = img
            }
        }
        
        cell.scrollView.setZoomScale(1, animated: true)
        
        cell.setZoomableView()
        
        cell.contentView.backgroundColor = .clear
        cell.img_main.backgroundColor = .clear
        
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        var visibleRect = CGRect()
        
        visibleRect.origin = coll_Images.contentOffset
        visibleRect.size = coll_Images.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = coll_Images.indexPathForItem(at: visiblePoint) else { return }
        indexNumber = indexPath.row
        
        if arr_images[indexPath.row]["orignal"].stringValue != ""{
            self.img_background.sd_setImage(with: URL(string: arr_images[indexPath.row]["orignal"].stringValue), placeholderImage: #imageLiteral(resourceName: "round"), options: .continueInBackground, progress: nil, completed: nil)
            self.img_background.sd_setImage(with: URL(string: arr_images[indexPath.row]["orignal"].stringValue)) { (img, error, cacheType, url) in
            }
        }
        
    }
    @IBAction func action_cancel(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
}

extension ImageController : URLSessionDelegate, URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        //        let written = byteFormatter.string(fromByteCount: totalBytesWritten)
        //        let expected = byteFormatter.string(fromByteCount: totalBytesExpectedToWrite)
        //        //print("Downloaded \(written) / \(expected)")
        let per = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite) * 100
        DispatchQueue.main.async {
            SVProgressHUD.showProgress((Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)), status: "\(per.clean)%\nTap to Cancel")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let data = try? Data(contentsOf: location), let _ = UIImage(data: data) {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                let compressedJPGImage = UIImage(data: data)
                UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
            }
        } else {
            fatalError("Cannot load the image")
        }
        
    }
}
