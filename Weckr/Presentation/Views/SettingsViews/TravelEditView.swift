//
//  TravelEditView.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class TravelEditView: BaseEditView, TravelEditViewProtocol {
    
    override init() {
        super.init()
        addSubviews()
        addSubview(segmentedControl)
        segmentedControl.autoCenterInSuperview()
        segmentedControl.autoSetDimensions(to: CGSize(width: 300, height: 50))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var segmentedControl = VehicleSegmentedControl(items: ["Car", "Pedestrian", "Transit"])
}
