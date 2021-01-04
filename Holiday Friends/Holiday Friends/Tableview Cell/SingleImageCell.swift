//
//  SingleImageCell.swift
//  HD Car Wallpapers
//
//  Created by Keyur Kankotiya on 01/06/19.
//  Copyright © 2019 Keyur Kankotiya. All rights reserved.
//

import UIKit

class SingleImageCell: UICollectionViewCell,UIGestureRecognizerDelegate,UIScrollViewDelegate {
    
    @IBOutlet var img_main: UIImageView!

    @IBOutlet weak var scrollView:UIScrollView!
    var tap_zoom : UITapGestureRecognizer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setZoomableView(){
        tap_zoom = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap_zoom.numberOfTapsRequired = 2
        img_main.addGestureRecognizer(tap_zoom)
        
        scrollView.delegate = self
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0//maximum zoom scale you want
        scrollView.zoomScale = 1.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img_main
    }
    
    
    @objc func doubleTapped() {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale, center: tap_zoom.location(in: tap_zoom.view)), animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }
    
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = img_main.frame.size.height / scale
        zoomRect.size.width  = img_main.frame.size.width  / scale
        let newCenter = img_main.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }


}
