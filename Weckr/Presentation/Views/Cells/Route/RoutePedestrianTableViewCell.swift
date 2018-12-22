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
        
        let text = maneuver.instruction.replacingOccurrences(of: "<[^>]+>",
                                                             with: "",
                                                             options: .regularExpression,
                                                             range: nil)
        let words = text.components(separatedBy: " ")
        
        let directionText = words.prefix(2).joined(separator: " ")
        let direction = DirectionInstruction(rawValue: directionText)
        
        let destination = words.dropFirst(3).prefix(1)

        infoView.titleLabel.text = direction?.localized.uppercased()
        infoView.timeLabel.text = "\(maneuver.length/60) MIN"
        infoView.infoLabel.text = destination.joined().replacingOccurrences(of: ".", with: "")
    }
    
    private func addSubviews() {
        tileView.addSubview(infoView)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Text.self
        infoView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        tileView.autoPinEdge(.bottom, to: .bottom, of: infoView, withOffset: insets.bottom)
    }
    
    let infoView: BasicInfoView = {
        let view = BasicInfoView.newAutoLayout()
        return view
    }()
}
