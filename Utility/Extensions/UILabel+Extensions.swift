//
//  UILabel+Extensions.swift
//  Weckr
//
//  Created by Tim Lehmann on 10.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    
    convenience init(text: String, coloredPart: String, textColor: UIColor, coloredColor: UIColor) {
        
        let attrText = NSMutableAttributedString.init(string: text)
        
        let totalRange = (text as NSString).range(of: text)
        let coloredRange = (text as NSString).range(of: (coloredPart))
        
        attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: totalRange)
        attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: coloredColor, range: coloredRange)
        
        self.init()
        self.attributedText = attrText
    }
}
