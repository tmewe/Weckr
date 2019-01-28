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
    var topLabel: WalkthroughTitleLabel { get }
    var button: RoundedButton { get }
}

protocol MorningRoutineEditViewProtocol: EditViewProtocol {
    var picker: TimePicker { get }
}

protocol TravelEditViewProtocol: EditViewProtocol {
    var segmentedControl: VehicleSegmentedControl { get }
}

protocol CalendarEditViewProtocol {
    var tableView: UITableView { get }
}

extension EditViewProtocol where Self: UIView {
    func addSubviews() {
        addSubview(topLabel)
        addSubview(button)
    }
    
    func setupConstraints() {
        let insets = Constraints.Main.Edit.self
        
        topLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: insets.titleTop)
        topLabel.autoPinEdge(.left, to: .left, of: self, withOffset: insets.titleLeft)
        topLabel.autoSetDimension(.width, toSize: insets.titleWidth)
        
        button.autoSetDimensions(to: CGSize(
            width: Constraints.Buttons.RoundedButton.width,
            height: Constraints.Buttons.RoundedButton.height))
        button.autoAlignAxis(.vertical, toSameAxisOf: self)
        button.autoPinEdge(toSuperviewSafeArea: .bottom,
                           withInset: insets.buttonBottom)
    }
}

