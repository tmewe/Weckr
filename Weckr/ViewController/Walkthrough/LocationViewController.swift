//
//  LocationViewController.swift
//  Weckr
//
//  Created by Tim Lehmann on 10.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class LocationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        view.addSubview(topLabel)
        view.addSubview(bottomLabel)
        
    }
    
    func setupConstraints() {
        topLabel.autoPinEdge(.top, to: .top, of: view, withOffset: Constraints.Walkthrough.Title.title1Top)
        topLabel.autoPinEdge(.left, to: .left, of: view, withOffset: Constraints.Walkthrough.Title.horizontalSides)
        topLabel.autoSetDimension(.width, toSize: Constraints.Walkthrough.Title.width)
        
        bottomLabel.autoPinEdge(.top, to: .bottom, of: topLabel, withOffset: Constraints.Walkthrough.Title.title2Offset)
        bottomLabel.autoPinEdge(.right, to: .right, of: view, withOffset: -Constraints.Walkthrough.Title.horizontalSides)
        bottomLabel.autoSetDimension(.width, toSize: Constraints.Walkthrough.Title.width)
        
        
    }
    
    
    
    let topLabel: UILabel = {
        var label = UILabel(
            text: "walkthrough.location.title".localized(),
            coloredPart: "walkthrough.location.title.coloredPart".localized(),
            textColor: .white,
            coloredColor: .walkthroughOrangeAccent)
            .configureForAutoLayout()
        
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    let bottomLabel: UILabel = {
        var label = UILabel(
            text: "walkthrough.location.title2".localized(),
            coloredPart: "walkthrough.location.title2.coloredPart".localized(),
            textColor: .white,
            coloredColor: .walkthroughOrangeAccent)
            .configureForAutoLayout()
        
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
}
