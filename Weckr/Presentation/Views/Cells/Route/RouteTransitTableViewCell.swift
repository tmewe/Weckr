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
        
        let leftColor = UIColor(hexString: line.foregroundColor)
        let rightColor = leftColor.darker()!
        gradient = (leftColor.cgColor, rightColor.cgColor)

        let words = getOn.instruction.components(separatedBy: " ")
        let stationsCount = words.suffix(2).naturalJoined().removeDots()
        
        headerInfo.leftLabel.text = line.name.uppercased() + " " + line.destination.uppercased()
        headerInfo.rightLabel.text = "\(Int(getOn.travelTime/60)) min".uppercased()
        
        departureTimeLabel.text = "08:27"
        arrivalTimeLabel.text = "08:27"
        firstStopLabel.text = firstStop
        finalStopLabel.text = finalStop
        stationsCountLabel.text = stationsCount
    }
    
    private func addSubviews() {
        tileView.addSubview(departureTimeLabel)
        tileView.addSubview(arrivalTimeLabel)
        tileView.addSubview(firstStopLabel)
        tileView.addSubview(finalStopLabel)
        tileView.addSubview(headerInfo)
        tileView.addSubview(stationsCountLabel)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Text.self
        
        headerInfo.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        
        departureTimeLabel.autoSetDimension(.width, toSize: 90)
        departureTimeLabel.autoPinEdge(.top, to: .bottom, of: headerInfo, withOffset: insets.largeSpacing)
        departureTimeLabel.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        
        firstStopLabel.autoPinEdge(.top, to: .bottom, of: headerInfo, withOffset: insets.largeSpacing)
        firstStopLabel.autoPinEdge(.left, to: .right, of: departureTimeLabel, withOffset: insets.smallSpacing)
        firstStopLabel.autoPinEdge(.right, to: .right, of: tileView, withOffset: -insets.right)
        
        arrivalTimeLabel.autoSetDimension(.width, toSize: 90)
        arrivalTimeLabel.autoPinEdge(.top, to: .bottom, of: departureTimeLabel, withOffset: insets.largeSpacing)
        arrivalTimeLabel.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        
        finalStopLabel.autoPinEdge(.top, to: .bottom, of: departureTimeLabel, withOffset: insets.largeSpacing)
        finalStopLabel.autoPinEdge(.left, to: .right, of: arrivalTimeLabel, withOffset: insets.smallSpacing)
        finalStopLabel.autoPinEdge(.right, to: .right, of: tileView, withOffset: -insets.right)
        
        stationsCountLabel.autoPinEdge(.top, to: .bottom, of: finalStopLabel, withOffset: insets.largeSpacing)
        stationsCountLabel.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        stationsCountLabel.autoPinEdge(.right, to: .right, of: tileView, withOffset: -insets.right)
        
        tileView.autoPinEdge(.bottom, to: .bottom, of: stationsCountLabel, withOffset: insets.bottom)
    }
    
    let headerInfo = BasicHeaderInfoView.newAutoLayout()
    let departureTimeLabel = LargeLabel.newAutoLayout()
    let arrivalTimeLabel = LargeLabel.newAutoLayout()
    let stationsCountLabel = SmallLabel.newAutoLayout()
    
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
}
