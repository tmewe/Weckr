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
    
    private let gradient = Gradient(left: UIColor.walkthroughOrangeAccent.cgColor,
                                    right: UIColor.backGroundColorTransparent.cgColor)
    
    override init() {
        super.init()
        addSubviews()
        addSubview(segmentedControl)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        segmentedControl.autoCenterInSuperview()
        segmentedControl.autoSetDimensions(to: CGSize(width: 300, height: 50))
        button.setGradientForButton(gradient)
        
        let strings = Strings.Walkthrough.Travel.self
        topLabel.setTextWithColoredPart(text: strings.title,
                                        coloredText: strings.titleColored,
                                        textColor: .white,
                                        coloredColor: UIColor.walkthroughOrangeAccent)
    }
    
    var segmentedControl = VehicleSegmentedControl(items: ["Car", "Pedestrian", "Transit"])
}
