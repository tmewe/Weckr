//
//  EditViewProtocol.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import Action

protocol EditViewProtocol {
    var topLabel: WalkthroughTitleLabel { get set }
    var button: RoundedButton { get set }
}

protocol MorningRoutineEditViewProtocol: EditViewProtocol {
    var picker: TimePicker { get set }
}

protocol TravelEditViewProtocol: EditViewProtocol {
    var segmentedControl: VehicleSegmentedControl { get set }
}

extension EditViewProtocol where Self: UIView {
    func addSubviews() {
        addSubview(topLabel)
        addSubview(button)
    }
    
    func setupConstraints() {
        let insets = Constraints.Walkthrough.Title.self
        
        topLabel.autoPinEdge(.top, to: .top, of: self, withOffset: insets.title1Top)
        topLabel.autoPinEdge(.left, to: .left, of: self, withOffset: insets.horizontalSides)
        topLabel.autoSetDimension(.width, toSize: insets.width)
        
        button.autoSetDimensions(to: CGSize(
            width: Constraints.Walkthrough.NextButton.width,
            height: Constraints.Walkthrough.NextButton.height))
        button.autoAlignAxis(.vertical, toSameAxisOf: self)
        button.autoPinEdge(toSuperviewSafeArea: .bottom,
                           withInset: Constraints.Walkthrough.NextButton.bottomOffset)
    }
}
