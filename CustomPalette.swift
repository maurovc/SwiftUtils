//
//  CustomPalette.swift
//  SwiftTest
//
//  Created by Mauro Vime Castillo on 1/2/16.
//  Copyright © 2016 Mauro Vime Castillo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    class func colorWith(hexString string: String, andAlpha alpha: CGFloat = 1.0) -> UIColor {
        var rgbValue:UInt32 = 0;
        let scanner = NSScanner(string: string)
        if let _ = string.rangeOfString("#") {
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgbValue)
        let div     = CGFloat(255)
        let red     = CGFloat((rgbValue & 0xFF0000) >> 24) / div
        let green   = CGFloat((rgbValue & 0x00FF00) >> 16) / div
        let blue    = CGFloat((rgbValue & 0x0000FF) >>  8) / div
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}