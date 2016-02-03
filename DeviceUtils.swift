//
//  DeviceUtils.swift
//  SwiftTest
//
//  Created by Mauro Vime Castillo on 31/1/16.
//  Copyright © 2016 Mauro Vime Castillo. All rights reserved.
//

import Foundation
import UIKit
import LocalAuthentication
import CoreLocation
import AddressBook

enum DeviceVersion : Int {
    case iPhone4 = 0
    case iPhone4S = 1
    case iPhone5 = 2
    case iPhone5S = 3
    case iPhone5C = 4
    case iPhone6 = 5
    case iPhone6P = 6
    case iPhone6S = 7
    case iPhone6SP = 8
    case iPodTouch = 9
    case Unknown = -1
}

class DeviceUtils {
    
    class func deviceBounds() -> CGRect {
        return UIScreen.mainScreen().bounds
    }
    
    class func deviceHeight() -> CGFloat {
        return deviceBounds().size.height
    }
    
    class func deviceWidth() -> CGFloat {
        return deviceBounds().size.width
    }
    
    class func deviceScale() -> CGFloat {
        return UIScreen.mainScreen().scale
    }
    
    @available(iOS 8.0, *)
    class func deviceNativeScale() -> CGFloat? {
        return UIScreen.mainScreen().nativeScale
    }
    
    class func clockIsSetTo24() -> Bool {
        let format = NSDateFormatter.dateFormatFromTemplate("j", options: 0, locale: NSLocale.currentLocale())
        let range = format?.rangeOfString("a")
        return (range == nil)
    }
    
    class func isPortrait() -> Bool {
        return deviceHeight() > deviceWidth()
    }
    
    class func hasTouchID() -> Bool {
        if #available(iOS 8.0, *) {
            let context = LAContext()
            var error: NSError?
            return context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error)
        } else {
            return false
        }
    }
    
    class func realOnePoint() -> CGFloat {
        if #available(iOS 8.0, *) {
            return 1.0 / deviceNativeScale()!
        } else {
            return 1.0 / deviceScale()
        }
    }
    
    class func deviceLanguage() -> String? {
        return NSBundle.mainBundle().preferredLocalizations.first
    }
    
    class func majorSystemVersion() -> Int {
        return Int(String(Array(arrayLiteral: UIDevice.currentDevice().systemVersion)[0]))!
    }
    
    class func appVersion() -> String {
        let dict = NSBundle.mainBundle().infoDictionary
        let val = dict!["CFBundleVersion"]
        return String(val)
    }
    
    class func notificationsEnabled() -> Bool {
        if #available(iOS 8.0, *) {
            return UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
        } else {
            return false
        }
    }
    
    class func enableNotifications() {
        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(forTypes: UIUserNotificationType([.Alert, .Badge, .Sound]), categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            UIApplication.sharedApplication().registerForRemoteNotificationTypes(UIRemoteNotificationType([.Alert, .Badge, .Sound]))
        }
    }
    
    class func locationEnabled() -> Bool {
        return CLLocationManager.authorizationStatus() != CLAuthorizationStatus.NotDetermined
    }
    
    @available(iOS 8.0, *)
    class func enableLocation(always: Bool, inUse: Bool) {
        let manager = CLLocationManager()
        if always {
            manager.requestAlwaysAuthorization()
        }
        if inUse {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    class func contactListEnabled() -> Bool {
        return ABAddressBookGetAuthorizationStatus() != ABAuthorizationStatus.NotDetermined
    }
    
    class func enableContactList() {
        var addressBook: ABAddressBookRef?
        var error: Unmanaged<CFError>?
        addressBook = ABAddressBookCreateWithOptions(nil,&error).takeRetainedValue()
        if let theBook: ABAddressBookRef = addressBook{
            ABAddressBookRequestAccessWithCompletion(theBook,{(granted, error) in
                    if granted{
                        print("Access is granted")
                    } else {
                        print("Access is not granted")
                    }
            })
        }
    }
    
    class func deviceName() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        _ = machineMirror.children.reduce("") { (identifier, element) in
            guard let value = element.value as? Int8 where value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return ""
    }
    
    class func deviceDirectoryURL() -> NSURL {
        let documentDirectoryURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return documentDirectoryURL.first!
    }
    
    class func currentDeviceFamily() -> DeviceVersion {
        switch isPortrait() ? deviceHeight() : deviceWidth() {
            
        case 480:   return DeviceVersion.iPhone4
        case 568:   return DeviceVersion.iPhone5
        case 667:   return DeviceVersion.iPhone6
        case 736:   return DeviceVersion.iPhone6P
        default:    return DeviceVersion.Unknown
            
        }
    }
    
    class func iphoneDevice() -> DeviceVersion {
        switch deviceName() {
            
        case "iPod5,1", "iPod7,1":                      return DeviceVersion.iPodTouch
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return DeviceVersion.iPhone4
        case "iPhone4,1":                               return DeviceVersion.iPhone4S
        case "iPhone5,1", "iPhone5,2":                  return DeviceVersion.iPhone5
        case "iPhone5,3", "iPhone5,4":                  return DeviceVersion.iPhone5C
        case "iPhone6,1", "iPhone6,2":                  return DeviceVersion.iPhone5S
        case "iPhone7,2":                               return DeviceVersion.iPhone6
        case "iPhone7,1":                               return DeviceVersion.iPhone6P
        case "iPhone8,1":                               return DeviceVersion.iPhone6S
        case "iPhone8,2":                               return DeviceVersion.iPhone6SP
        default:                                        return DeviceVersion.Unknown
            
        }
    }
    
}

