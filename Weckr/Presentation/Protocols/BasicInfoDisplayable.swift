//
//  BasicInfoDisplayable.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol BasicHeaderInfoDisplayable {
    var headerInfoView: BasicHeaderInfoView { get set }
}

protocol BasicInfoDisplayable {
    associatedtype Configuration
    var infoView: BasicInfoView { get set }
    func configure(with configuration: Configuration)
}

protocol BasicInfoSubtitleDisplayable: BasicInfoDisplayable {
    var distanceLabel: SmallLabel { get set }
}

extension BasicInfoDisplayable where Self: TileTableViewCell {
    func addSubviews() {
        tileView.addSubview(infoView)
    }
    
    func setupConstraints() {
        let insets = Constraints.Main.Text.self
        infoView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        tileView.autoPinEdge(.bottom, to: .bottom, of: infoView, withOffset: insets.bottom)
    }
}

extension BasicInfoSubtitleDisplayable where Self: TileTableViewCell {
    func addSubviews() {
        tileView.addSubview(infoView)
        tileView.addSubview(distanceLabel)
    }
    
    func setupConstraints() {
        let insets = Constraints.Main.Text.self
        infoView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        
        distanceLabel.autoPinEdge(.top, to: .bottom, of: infoView, withOffset: insets.largeSpacing)
        distanceLabel.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        distanceLabel.autoPinEdge(.right, to: .right, of: tileView, withOffset: insets.right)
        
        tileView.autoPinEdge(.bottom, to: .bottom, of: distanceLabel, withOffset: insets.bottom)
    }
}
