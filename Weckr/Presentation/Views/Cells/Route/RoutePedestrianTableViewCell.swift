//
//  RoutePedestrianTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 22.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class RoutePedestrianTableViewCell: TileTableViewCell, BasicInfoSubtitleDisplayable {
    
    typealias Configuration = Maneuver
    
    var infoView = BasicInfoView()
    var distanceLabel = SmallLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = Gradient(left: UIColor.routeCellLeft.cgColor,
                            right: UIColor.routeCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with configuration: Maneuver) {
        
        // Turn left onto Danziger Straße. Go for 64 m.
        let sentences = configuration.instruction.components(separatedBy: ".")
        let words = sentences.first!.components(separatedBy: " ")
        // Turn left onto Danziger Straße.
        
        //Instruction hat 2 Wörter
        let directionText = words.prefix(2).naturalJoined().noDots
        // Turn left
        
        var direction = DirectionInstruction(rawValue: directionText)
        if direction == nil {
            //Instruction hat 3 Wörter
            let directionText = words.prefix(3).naturalJoined().noDots
            direction = DirectionInstruction(rawValue: directionText)
        }
        
        if direction == nil {
            //Instruction hat 6 Wörter
            let directionText = words.prefix(6).naturalJoined().noDots
            direction = DirectionInstruction(rawValue: directionText)
        }
        
        var destination = ""
        if direction != nil {
            switch direction! {
            case .roundabout:
                destination = words.dropFirst(9).naturalJoined()
            case .slightlyRight, .slightlyLeft:
                destination = words.dropFirst(4).naturalJoined()
            case .takeStreetLeft, .takeStreetRight:
                destination = words.dropFirst(6).naturalJoined()
            default:
                destination = words.dropFirst(3).naturalJoined()
                // Danziger Straße
            }
        }
        
        let duration = TimeInterval(configuration.travelTime)
        let durationText = duration.timeSpan.uppercased()
        
        let distance = Int(configuration.length)
        let distanceText = distance < 1000
            ? "\(distance) \(Strings.Directions.meters)"
            : "\(distance / 1000) \(Strings.Directions.kilometers)"
        
        infoView.headerInfoView.leftLabel.text = direction?.localized.uppercased()
        infoView.headerInfoView.rightLabel.text = durationText
        infoView.infoLabel.text = destination.noDots
        distanceLabel.text = distanceText
    }
}
