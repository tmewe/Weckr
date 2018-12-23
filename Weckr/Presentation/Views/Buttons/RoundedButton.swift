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
    init(text: String, color: UIColor) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(text, for: .normal)
        backgroundColor = color
        titleLabel?.font = UIFont.systemFont(ofSize: Font.Size.Walkthorugh.nextButton,
                                             weight: UIFont.Weight.bold)
        layer.cornerRadius = layer.frame.height / 2
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
