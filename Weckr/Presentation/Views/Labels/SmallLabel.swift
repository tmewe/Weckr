//
//  SmallLabel.swift
//  Weckr
//
//  Created by Tim Mewe on 22.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class SmallLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        font = UIFont.systemFont(ofSize: Font.Size.TileCell.title, weight: .semibold)
        textColor = .white
        textAlignment = .left
        alpha = 0.7
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
