//
//  RouteTransitTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 22.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class RouteTransitTableViewCell: TileTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = (UIColor.routeCellLeft.cgColor, UIColor.routeCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with getOn: Maneuver, getOff: Maneuver, lines: [TransitLine]) {
        guard let firstStop = getOn.stopName,
            let finalStop = getOff.stopName,
            let lineId = getOn.lineId else { return }
        
        var optLine: TransitLine?
        for l in lines {
            if l.id == lineId {
                optLine = l
            }
        }
        
        guard let line = optLine else { return }
        
        headerInfo.leftLabel.text = line.name.uppercased() + " " + line.destination.uppercased()
        headerInfo.rightLabel.text = "\(Int(getOn.travelTime/60)) min".uppercased()
        
        departureTimeLabel.text = "08:27"
        arrivalTimeLabel.text = "08:27"
        firstStopLabel.text = firstStop
        finalStopLabel.text = finalStop
    }
    
    private func addSubviews() {
        topStackView.addArrangedSubview(departureTimeLabel)
        topStackView.addArrangedSubview(firstStopLabel)
        bottomStackView.addArrangedSubview(arrivalTimeLabel)
        bottomStackView.addArrangedSubview(finalStopLabel)
        tileView.addSubview(headerInfo)
        tileView.addSubview(topStackView)
        tileView.addSubview(bottomStackView)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Text.self
        
        departureTimeLabel.autoSetDimension(.width, toSize: 90)
        arrivalTimeLabel.autoSetDimension(.width, toSize: 90)
        
        headerInfo.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        topStackView.autoPinEdge(.top, to: .bottom, of: headerInfo, withOffset: insets.largeSpacing)
        topStackView.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        topStackView.autoPinEdge(.right, to: .right, of: tileView, withOffset: -insets.right)
        
        bottomStackView.autoPinEdge(.top, to: .bottom, of: topStackView, withOffset: insets.largeSpacing)
        bottomStackView.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        bottomStackView.autoPinEdge(.right, to: .right, of: tileView, withOffset: -insets.right)
        
        tileView.autoPinEdge(.bottom, to: .bottom, of: bottomStackView, withOffset: insets.bottom)
    }
    
    let headerInfo = BasicHeaderInfoView.newAutoLayout()
    let departureTimeLabel = LargeLabel.newAutoLayout()
    let arrivalTimeLabel = LargeLabel.newAutoLayout()
    
    let firstStopLabel: LargeLabel = {
        let label = LargeLabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.info, weight: .regular)
        return label
    }()
    
    let finalStopLabel: LargeLabel = {
        let label = LargeLabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.info, weight: .regular)
        return label
    }()
    
    private let topStackView: UIStackView = {
        let stack = UIStackView.newAutoLayout()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .top
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private let bottomStackView: UIStackView = {
        let stack = UIStackView.newAutoLayout()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .top
        stack.distribution = .fillProportionally
        return stack
    }()
}
