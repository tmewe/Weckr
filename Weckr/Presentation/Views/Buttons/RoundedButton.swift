//
//  RoundedButton.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    init(text: String, gradient: Gradient?) {
        
        let insets = Constraints.Buttons.RoundedButton.self
        super.init(frame: CGRect(x: 0, y: 0, width: insets.width, height: insets.height))
        translatesAutoresizingMaskIntoConstraints = false
        autoSetDimensions(to: CGSize(width: insets.width, height: insets.height))

        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: Font.Size.Walkthorugh.nextButton,
                                             weight: UIFont.Weight.bold)
        
        layer.cornerRadius = layer.frame.height / 2
        layer.masksToBounds = true
        backgroundColor = .clear

        guard gradient != nil else {
            return
        }
        
        setGradientForButton(gradient!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
