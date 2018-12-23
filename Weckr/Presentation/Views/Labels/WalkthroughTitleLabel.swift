//
//  WalkthroughTitleLabel.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class WalkthroughTitleLabel: UILabel {
    init(title: String, alignment: NSTextAlignment) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        text = title
        textColor = .white
        textAlignment = alignment
        font = UIFont.systemFont(ofSize: Font.Size.Walkthorugh.title, weight: .bold)
        numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
