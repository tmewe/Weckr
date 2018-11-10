//
//  LandingPageViewController.swift
//  Weckr
//
//  Created by Tim Mewe on 03.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit

class LandingPageViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews() {
        view.addSubview(topLabel)
    }
    
    func setupConstraints() {
        topLabel.autoPinEdge(.top, to: .top, of: view, withOffset: Constraints.Walkthrough.Title.title1Top)
        topLabel.autoPinEdge(.left, to: .left, of: view, withOffset: Constraints.Walkthrough.Title.horizontalSides)
        topLabel.autoSetDimension(.width, toSize: Constraints.Walkthrough.Title.width)

    }

    
    
    let topLabel: UILabel = {
        var label = UILabel(
            text: "walkthrough.landing.title".localized(),
            coloredPart: "walkthrough.landing.title.coloredPart".localized(),
            textColor: .white,
            coloredColor: .walkthroughPurpleAccent)
            .configureForAutoLayout()
    
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
}
