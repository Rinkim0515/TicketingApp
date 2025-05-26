//
//  UIColor+.swift
//  GGV
//
//  Created by KimRin on 4/24/25.
//

import UIKit

extension UIColor {
    
    static let primaryBlue = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    static let lightBlue = UIColor(hexCode: "99b8ff", alpha: 1.0)
    static let lightPink = UIColor(hexCode: "ff99a3", alpha: 1.0)
    static let overlayBlue = UIColor.systemBlue.withAlphaComponent(0.9)
    
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
