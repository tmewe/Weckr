//
//  UILabel+Extensions.swift
//  Weckr
//
//  Created by Tim Lehmann on 10.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

public struct LabelColoredPartInfo {
    let text: String
    let color: UIColor
}

extension UILabel {
    
    func setTextWithColoredPart(text: String, coloredText: String, textColor: UIColor, coloredColor: UIColor) {
        
        let attrText = NSMutableAttributedString.init(string: text)
        
        let totalRange = (text as NSString).range(of: text)
        let coloredRange = (text as NSString).range(of: (coloredText))
        
        attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: totalRange)
        attrText.addAttribute(NSAttributedString.Key.foregroundColor, value: coloredColor, range: coloredRange)
        
        self.attributedText = attrText
    }
}

extension Reactive where Base:UILabel {
    
    public var coloredPart: Binder<LabelColoredPartInfo> {
        return Binder(self.base){ label, colored in
            label.setTextWithColoredPart(
                text: label.attributedText?.string ?? label.text ?? "",
                coloredText: colored.text,
                textColor: label.textColor,
                coloredColor: colored.color)
        }
    }
}

