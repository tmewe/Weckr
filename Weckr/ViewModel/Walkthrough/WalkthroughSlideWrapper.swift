//
//  WalkthroughSlideWrapper.swift
//  Weckr
//
//  Created by Tim Lehmann on 10.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit.UIView
import UIKit.UIColor


class WalkthroughSlideWrapper {
    
    let view: UIView
    let buttonColor: UIColor
    let buttonText: String
    
    init(view: UIView, buttonColor: UIColor, buttonText: String) {
        self.view = view
        self.buttonColor = buttonColor
        self.buttonText = buttonText
    }
}
