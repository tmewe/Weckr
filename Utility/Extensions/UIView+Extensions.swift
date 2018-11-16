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



extension Reactive where Base: UIView {
    
    public var gradientColor: Binder<[CGColor]> {
        return Binder(self.base) { (view, colors) in
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = colors
            gradientLayer.locations = [0.0, 1.0]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.5, y: 1.5)
            gradientLayer.cornerRadius = gradientLayer.frame.height / 2

            if let oldGradientLayer = view.layer.sublayers!.first as? CAGradientLayer {
                view.layer.replaceSublayer(oldGradientLayer, with: gradientLayer)
            }
            else {
                view.layer.insertSublayer(gradientLayer, at: 0)
            }

        }
    }
}
