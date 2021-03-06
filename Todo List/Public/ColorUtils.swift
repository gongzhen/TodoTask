//
//  ColorUtils.swift
//  Todo List
//
//  Created by gongzhen on 7/29/16.
//  Copyright © 2016 gongzhen. All rights reserved.
//

import Foundation
import UIKit

class ColorUtils {
    
    class func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue:
            CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: CGFloat(1.0))
    }
    
    class func systemGreen() -> UIColor {
        return ColorUtils.UIColorFromRGB(0x7cc576)
    }
}