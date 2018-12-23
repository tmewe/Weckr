//
//  RoutePedestrianTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 22.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class RoutePedestrianTableViewCell: TileTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = (UIColor.routeCellLeft.cgColor, UIColor.routeCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with maneuver: Maneuver) {
        
        // Turn left onto Danziger Straße. Go for 64 m.
        let sentences = maneuver.instruction.components(separatedBy: ".")
        let words = sentences.first!.components(separatedBy: " ")
        // Turn left onto Danziger Straße.

        let directionText = words.prefix(2).naturalJoined().removeDots()
        // Turn left
        
        let direction = DirectionInstruction(rawValue: directionText)
        
        var destination = ""
        if direction != nil {
            switch direction! {
            case .roundabout:
                destination = words.dropFirst(9).naturalJoined()
            default:
                destination = words.dropFirst(3).naturalJoined()
                // Danziger Straße
            }
        }
        
        let duration = Int(maneuver.travelTime/60)
        let durationText = duration > 0 ? "\(duration) MIN" : ""

        infoView.headerInfo.leftLabel.text = direction?.localized.uppercased()
        infoView.headerInfo.rightLabel.text = durationText
        infoView.infoLabel.text = destination.removeDots()
        distanceLabel.text = "\(Int(maneuver.length)) meters"
    }
    
    private func addSubviews() {
        tileView.addSubview(infoView)
        tileView.addSubview(distanceLabel)
    }
    
    private func setupConstraints() {
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
    
    let infoView: BasicInfoView = {
        let view = BasicInfoView.newAutoLayout()
        return view
    }()
    
    let distanceLabel = SmallLabel.newAutoLayout()
}
