//
//  UIColor+Extensions.swift
//  Weckr
//
//  Created by Tim Lehmann on 09.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    
    convenience init(hexString: String) {
        
        let hexString: String = (hexString as NSString).trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner          = Scanner(string: hexString as String)
        
        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    func interpolateTo(color: UIColor, fraction: CGFloat) -> UIColor? {
        
        let f = min(max(0, fraction), 1)
        
        guard let c1 = self.cgColor.components, let c2 = color.cgColor.components else { return nil }
        
        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
    
    func interpolateTo(colors: [UIColor], value: CGFloat) -> UIColor{
        
        var colors = colors
        
        let v = min(max(0, value), CGFloat(colors.count))
        
        colors.insert(self, at: 0)
        
        let color1 = colors[Int(floor(v))]
        let color2 = colors[Int(ceil(v))]
        
        return (color1.interpolateTo(color: color2, fraction: value - floor(value)) ?? self)
        
    }
    
    class var transparent: UIColor {
        return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    class var backgroundColor: UIColor {
        return #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 1)
    }
    
    class var backGroundColorTransparent: UIColor {
        return #colorLiteral(red: 0.1411764706, green: 0.1411764706, blue: 0.1411764706, alpha: 0)
    }
    
    class var textColor: UIColor {
        return UIColor.white
    }
    
    class var walkthroughPreviousButtonColor: UIColor {
        return UIColor(white: CGFloat(1), alpha: CGFloat(0.5))
    }
    
    class var walkthroughPurpleAccent: UIColor {
        return #colorLiteral(red: 0.7568627451, green: 0.2, blue: 0.7725490196, alpha: 1)
    }
    
    class var walkthroughGreenAccent: UIColor {
        return #colorLiteral(red: 0.1529411765, green: 0.6941176471, blue: 0.4039215686, alpha: 1)
    }
    
    class var walkthroughOrangeAccent: UIColor {
        return #colorLiteral(red: 0.9294117647, green: 0.568627451, blue: 0.4156862745, alpha: 1)
    }
    
    class var walkthroughBlueAccent: UIColor {
        return #colorLiteral(red: 0.3294117647, green: 0.5176470588, blue: 1, alpha: 1)
    }
    
    class var walkthroughRedAccent: UIColor {
        return #colorLiteral(red: 0.968627451, green: 0.2588235294, blue: 0.2156862745, alpha: 1)
    }
    
    class var walkthroughTealAccent: UIColor {
        return #colorLiteral(red: 0.1960784314, green: 0.9098039216, blue: 0.737254902, alpha: 1)
    }
    
}
