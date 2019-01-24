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
    public func setGradientForButton(_ gradient: Gradient) {
        let cornerRadius: CGFloat = frame.height / 2
        setGradient(gradient, radius: cornerRadius)
    }
    
    public func setGradientForCell(_ gradient: Gradient) {
        let cornerRadius: CGFloat = 14
        setGradient(gradient, radius: cornerRadius)
    }
    
    public func setGradient(_ gradient: Gradient, radius: CGFloat) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [gradient.left, gradient.right]
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
    
    private struct AnimationKey {
        static let Rotation = "rotation"
        static let Bounce = "bounce"
    }
    
    public func wiggle(){
        
        let wiggleBounceY = 2.0
        let wiggleBounceDuration = 0.18
        let wiggleBounceDurationVariance = 0.025
        
        let wiggleRotateAngle = 0.02
        let wiggleRotateDuration = 0.14
        let wiggleRotateDurationVariance = 0.025
        
        
        //Create rotation animation
        let rotationAnimation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.values = [-wiggleRotateAngle, wiggleRotateAngle]
        rotationAnimation.autoreverses = true
        rotationAnimation.duration = randomize(interval: wiggleRotateDuration, withVariance: wiggleRotateDurationVariance)
        rotationAnimation.repeatCount = .infinity
        
        //Create bounce animation
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceAnimation.values = [wiggleBounceY, 0]
        bounceAnimation.autoreverses = true
        bounceAnimation.duration = randomize(interval: wiggleBounceDuration, withVariance: wiggleBounceDurationVariance)
        bounceAnimation.repeatCount = .infinity
        
        //Apply animations to view
        UIView.animate(withDuration: 0) {
            self.layer.add(rotationAnimation, forKey: AnimationKey.Rotation)
            self.layer.add(bounceAnimation, forKey: AnimationKey.Bounce)
            self.transform = .identity
        }
    }
    
    // Utility
    
    private func randomize(interval: TimeInterval, withVariance variance: Double) -> Double{
        let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
        return interval + variance * random
    }
}

extension Reactive where Base: UIView {
    
    public var gradientColorButton: Binder<Gradient> {
        return Binder(self.base) { view, gradient in
            view.setGradientForButton(gradient)
        }
    }
}
