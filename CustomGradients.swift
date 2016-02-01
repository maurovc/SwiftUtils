//
//  CustomGradients.swift
//  SwiftTest
//
//  Created by Mauro Vime Castillo on 1/2/16.
//  Copyright © 2016 Mauro Vime Castillo. All rights reserved.
//

import Foundation
import UIKit

struct GradientElement {
    let color: CGColorRef
    let position: Float
    
    init(color: UIColor, pos: Float) {
        self.color = color.CGColor
        self.position = pos
    }
}

extension CAGradientLayer {
    
    class func customGradient(forColors colors:GradientElement..., atAngle angle: Double) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        var theColors: [CGColorRef] = []
        var theLocations: [Float] = []
        for element in colors {
            theColors.append(element.color)
            theLocations.append(element.position)
        }
        gradient.colors = theColors
        gradient.locations = theLocations
        
        let theAngle = angle / 360.0
        
        let startX = CGFloat(pow(sin(2.0 * M_PI * ((theAngle + 0.75) / 2.0)) , 2.0))
        let startY = CGFloat(pow(sin(2.0 * M_PI * ((theAngle + 0.00) / 2.0)) , 2.0))
        let endX   = CGFloat(pow(sin(2.0 * M_PI * ((theAngle + 0.25) / 2.0)) , 2.0))
        let endY   = CGFloat(pow(sin(2.0 * M_PI * ((theAngle + 0.50) / 2.0)) , 2.0))
        
        gradient.startPoint = CGPointMake(startX, startY)
        gradient.endPoint = CGPointMake(endX, endY)
        
        return gradient
    }
    
}