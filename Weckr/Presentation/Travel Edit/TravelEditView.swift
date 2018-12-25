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
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        addSubview(segmentedControl)
        addSubview(switchContainer)
        addSubview(weatherSwitch)
        addSubview(infoButton)
        addSubview(infoLabel)
        
        button.setGradientForButton(gradient)
        
        let strings = Strings.Walkthrough.Travel.self
        topLabel.setTextWithColoredPart(text: strings.title,
                                        coloredText: strings.titleColored,
                                        textColor: .white,
                                        coloredColor: UIColor.walkthroughOrangeAccent)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Edit.self
        segmentedControl.autoCenterInSuperview()
        segmentedControl.autoSetDimensions(to: CGSize(width: 300, height: 50))
        
        switchContainer.autoPinEdge(.top, to: .bottom, of: segmentedControl)
        switchContainer.autoPinEdge(.bottom, to: .top, of: button)
        switchContainer.autoPinEdge(.left, to: .left, of: self)
        switchContainer.autoPinEdge(.right, to: .right, of: self)
        
        weatherSwitch.autoAlignAxis(.horizontal,
                                    toSameAxisOf: switchContainer,
                                    withOffset: insets.switchOffset)
        weatherSwitch.autoPinEdge(.right, to: .right, of: self, withOffset: -insets.switchRight)
        
//        infoButton.autoSetDimensions(to: CGSize(width: 20, height: 20))
        infoButton.autoAlignAxis(.horizontal, toSameAxisOf: weatherSwitch)
        infoButton.autoPinEdge(.right, to: .left, of: weatherSwitch, withOffset: -20)
        
        infoLabel.autoPinEdge(.left, to: .left, of: self, withOffset: insets.titleLeft)
        infoLabel.autoPinEdge(.right, to: .left, of: infoButton, withOffset: -50)
        infoLabel.autoAlignAxis(.horizontal, toSameAxisOf: weatherSwitch)
        infoLabel.autoSetDimension(.height, toSize: 30)
    }
    
    lazy var segmentedControl = VehicleSegmentedControl(items: ["Car", "Pedestrian", "Transit"])
    lazy var switchContainer = UIView.newAutoLayout()
    lazy var weatherSwitch: UISwitch = {
        let sw = UISwitch.newAutoLayout()
        sw.tintColor = .walkthroughOrangeAccent
        sw.onTintColor = .walkthroughOrangeAccent
        return sw
    }()
    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = .walkthroughOrangeAccent
        return button
    }()
    lazy var infoLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = .white
        label.textAlignment = .left
        label.alpha = 0.7
        label.text = "Adjust for weather"
        return label
    }()
}
