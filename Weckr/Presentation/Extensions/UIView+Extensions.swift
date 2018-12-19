//
//  UIView+Extensions.swift
//  Weckr
//
//  Created by Tim Lehmann on 10.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreGraphics


extension UIView {
    public func setGradientForButton(colors: (first: CGColor, second: CGColor)) {
        let cornerRadius: CGFloat = frame.height / 2
        setGradient(colors: colors, radius: cornerRadius)
    }
    
    public func setGradientForCell(colors: (first: CGColor, second: CGColor)) {
        let cornerRadius: CGFloat = 14
        setGradient(colors: colors, radius: cornerRadius)
    }
    
    public func setGradient(colors: (first: CGColor, second: CGColor), radius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [colors.first, colors.second]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.5, y: 1.5)
        gradientLayer.cornerRadius = radius
        
        if let oldGradientLayer = layer.sublayers?.first as? CAGradientLayer {
            layer.replaceSublayer(oldGradientLayer, with: gradientLayer)
        }
        else {
            layer.insertSublayer(gradientLayer, at: 0)
        }
    }
}

extension Reactive where Base: UIView {
    
    public var gradientColorButton: Binder<[CGColor]> {
        return Binder(self.base) { view, colors in
            guard let first = colors.first, let second = colors.last else { return }
            let tupel = (first, second)
            view.setGradientForButton(colors: tupel)
        }
    }
}
