//
//  BlurBackgroundDisplayable.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol BlurBackgroundDisplayable {
    var blurEffectView: UIVisualEffectView { get set }
}

extension BlurBackgroundDisplayable where Self: UIView {
    var blurEffectView: UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    }
}
