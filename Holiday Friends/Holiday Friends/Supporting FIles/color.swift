//
//  global.swift
//  Direct Bazaar
//
//  Created by Jainish on 02/12/17.
//  Copyright © 2017 Assure live technology. All rights reserved.
//

import Foundation
import UIKit

var color_background: UIColor = UIColor.init(red: 246/255, green: 247/255, blue: 248/255, alpha: 1)
var color_shadow: UIColor = UIColor.init(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
var color_pass: UIColor = UIColor.init(red: 116/255, green: 170/255, blue: 0/255, alpha: 1)
var cocolor_shadow: UIColor = UIColor.init(red: 98/255, green: 98/255, blue: 98/255, alpha: 1)
var color_green: UIColor = UIColor.init(red: 111/255, green: 207/255, blue: 60/255, alpha: 1)
var color_shade_first: UIColor = UIColor.init(red: 255/255, green: 141/255, blue: 0/255, alpha: 1)
var color_shade_second: UIColor = UIColor.init(red: 255/255, green: 217/255, blue: 0/255, alpha: 1)

enum AssetsColor {
    case white
    case black
    case absent
    case leave
    case present
    case seprator
    case gray
    case green
    case textGray
    case background
    case gradiantStart
    case gradiantEnd
    case mainColor
    case textFielBG
}

extension UIColor {
    
    static func appColor(_ name: AssetsColor) -> UIColor? {
        switch name {
        case .white:
            return UIColor(named: "Font White")
        case .black:
            return UIColor(named: "Black")
        case .absent:
            return UIColor(named: "Color Absent")
        case .leave:
            return UIColor(named: "Color Leave")
        case .present:
            return UIColor(named: "Color Present")
        case .seprator:
            return UIColor(named: "seprator")
        case .gray:
            return UIColor(named: "Font Gray")
        case .green:
            return UIColor(named: "Color Green")
        case .textGray:
            return UIColor(named: "Color Text Gray")
        case .background:
            return UIColor(named: "Background")
        case .gradiantStart:
            return UIColor(named: "Gradient Start")
        case .gradiantEnd:
            return UIColor(named: "Gradient End")
        case .mainColor:
            return UIColor(named: "Main")
        case .textFielBG:
            return UIColor(named: "TextField Background")
        }
    }
}
