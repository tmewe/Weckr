//
//  TileView.swift
//  ChatAnalyzer
//
//  Created by Tim Mewe on 24.03.18.
//  Copyright © 2018 Tim Mewe. All rights reserved.
//

import Foundation
import UIKit

class TileView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 14
        
        layer.shadowColor = UIColor.shadow.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 1); //3
        layer.shadowRadius = 4 //7
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
