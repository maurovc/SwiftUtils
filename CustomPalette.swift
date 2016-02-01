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
    
    public convenience init(rgb string: String, alpha: CGFloat = 1.0) {
        var rgbValue: UInt32 = 0;
        let scanner = NSScanner(string: string)
        if let _ = string.rangeOfString("#") {
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgbValue)
        let div     = CGFloat(255)
        let red     = CGFloat((rgbValue & 0xFF0000) >> 16) / div
        let green   = CGFloat((rgbValue & 0x00FF00) >>  8) / div
        let blue    = CGFloat( rgbValue & 0x0000FF       ) / div
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    public convenience init(rgba string: String) {
        var rgbaValue: UInt32 = 0;
        let scanner = NSScanner(string: string)
        if let _ = string.rangeOfString("#") {
            scanner.scanLocation = 1
        }
        scanner.scanHexInt(&rgbaValue)
        let div     = CGFloat(255)
        let red     = CGFloat((rgbaValue & 0xFF000000) >> 24) / div
        let green   = CGFloat((rgbaValue & 0x00FF0000) >> 16) / div
        let blue    = CGFloat((rgbaValue & 0x0000FF00) >>  8) / div
        let alpha   = CGFloat( rgbaValue & 0x000000FF       ) / div
        self.init(red: red, green: green, blue: blue, alpha: alpha)
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