//
//  ImageUtils.swift
//  SwiftTest
//
//  Created by Mauro Vime Castillo on 31/1/16.
//  Copyright © 2016 Mauro Vime Castillo. All rights reserved.
//

import Foundation
import UIKit

class ImageUtils {
    
    class func cropImage(image: UIImage, rect: CGRect) -> UIImage {
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        let drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, image.size.width, image.size.height)
        CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height))
        image.drawInRect(drawRect)
        let subImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return subImage
    }
    
    class func scaleImage(image: UIImage, toSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    class func maskImage(image: UIImage, withMask maskImage: UIImage) -> UIImage {
        let maskRef = maskImage.CGImage
        let mask = CGImageMaskCreate(CGImageGetWidth(maskRef), CGImageGetHeight(maskRef), CGImageGetBitsPerComponent(maskRef), CGImageGetBitsPerPixel(maskRef), CGImageGetBytesPerRow(maskRef), CGImageGetDataProvider(maskRef), nil, false)
        let maskedImageRef = CGImageCreateWithMask(image.CGImage, mask)
        return UIImage(CGImage: maskedImageRef!)
    }
    
    class func imageWithView(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, DeviceUtils.deviceScale())
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.renderInContext(context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        } else {
            image = nil
        }
        UIGraphicsEndImageContext()
        return image
    }
    
    class func convertImageToGrayScale(image: UIImage) -> UIImage {
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let imageRect = CGRectMake(0, 0, imageWidth, imageHeight)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        var bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.None.rawValue)
        var context = CGBitmapContextCreate(nil, Int(imageWidth), Int(imageHeight), 8, 0, colorSpace, bitmapInfo.rawValue)
        
        CGContextDrawImage(context, imageRect, image.CGImage)
        
        let grayImage = CGBitmapContextCreateImage(context)
        bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.Only.rawValue)
        context = CGBitmapContextCreate(nil, Int(imageWidth), Int(imageHeight), 8, 0, nil, bitmapInfo.rawValue)
        
        CGContextDrawImage(context, imageRect, image.CGImage)
        
        let mask = CGBitmapContextCreateImage(context)
        return UIImage(CGImage: CGImageCreateWithMask(grayImage, mask)!, scale: image.scale, orientation: image.imageOrientation)
    }
    
    class func qrCodeFromString(string: String) -> CIImage? {
        let data = string.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            return filter.outputImage
        } else {
            return nil
        }
    }
    
    class func qrCodeFromString(string: String, forSize size: CGSize) -> UIImage? {
        if let qrImage = self.qrCodeFromString(string) {
            let scaleX = size.width / qrImage.extent.size.width
            let scaleY = size.height / qrImage.extent.size.height
            let transformedImage = qrImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
            return UIImage(CIImage: transformedImage)
        } else {
            return nil;
        }
    }
    
}
