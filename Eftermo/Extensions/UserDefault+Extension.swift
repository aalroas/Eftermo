//
//  UserDefault+Extension.swift
//  Eftermo
//
//  Created by Abdulsalam Alroas on 14/11/2020.
//

import Foundation

import Foundation
import UIKit


extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


extension UserDefaults {
    var badgeNumber: Int {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            integer(forKey: #function)
        }
    }
    
   
    
    var username: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    
    
    var password: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    var accessToken: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    var DeviceToken: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    
    var isNotificationPermissionDdismissed: Bool {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            bool(forKey: #function)
        }
    }
    
    
    var isNotificationPermissionGranted: Bool {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            bool(forKey: #function)
        }
    }
    
    
    var ServisDurumuStatus: Bool {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            bool(forKey: #function)
        }
    }
    
    
    var anlikBildirimStatus: Bool {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            bool(forKey: #function)
        }
    }
    
    var akilliBildirimStatus: Bool {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            bool(forKey: #function)
        }
    }
    
    var smsBildirimStatus: Bool {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            bool(forKey: #function)
        }
    }
    
 
    
    func removeAll() {
        let dictionary = dictionaryRepresentation()
        dictionary.keys.forEach { key in
            removeObject(forKey: key)
        }
    }
    
    
//    func removeAll() {
//        UserDefaults.standard.removeObject(forKey: "isNotificationPermissionDdismissed")
//        UserDefaults.standard.removeObject(forKey: "accessToken")
//        UserDefaults.standard.removeObject(forKey: "badgeNumber")
//        UserDefaults.standard.removeObject(forKey: "nightMode")
//        UserDefaults.standard.removeObject(forKey: "username")
//        UserDefaults.standard.removeObject(forKey: "password")
//        UserDefaults.standard.removeObject(forKey: "serverKey")
//    }
}

