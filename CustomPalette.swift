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
    
    class func colorWith(hexString string: String, andAlpha alpha: CGFloat) -> UIColor {
        var rgbValue: UInt32 = 0;
        let scanner = NSScanner(string: string)
        if let _ = string.rangeOfString("#") {
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgbValue)
        let divisor = CGFloat(255)
        let red     = CGFloat((rgbValue & 0xFF0000) >> 16) / divisor
        let green   = CGFloat((rgbValue & 0x00FF00) >>  8) / divisor
        let blue    = CGFloat( rgbValue & 0x0000FF       ) / divisor
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public func hexString(alpha: Bool) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var result = String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        if (alpha) {
            result += String(format: "%02X",Int(a * 255))
        }
        return result
    }
    
}