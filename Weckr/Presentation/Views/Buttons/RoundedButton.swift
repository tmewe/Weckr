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
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: Font.Size.Walkthorugh.nextButton,
                                             weight: UIFont.Weight.bold)
        layer.cornerRadius = layer.frame.height / 2
        layer.masksToBounds = true
        backgroundColor = .clear

        let insets = Constraints.Walkthrough.NextButton.self
        autoSetDimensions(to: CGSize(width: insets.width, height: insets.height))

        guard gradient != nil else {
            return
        }
        
        setGradientForButton(gradient!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
