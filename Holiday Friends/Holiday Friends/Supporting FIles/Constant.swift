//
//  Constant.swift
//  BunkerBranding
//
//  Created by Jainish PlanetX on 27/05/19.
//  Copyright © 2019 PlanetX Technologies. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
