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
            let lastStop = getOff.stopName,
            let lineId = getOn.lineId else { return }
        
        headerInfo.leftLabel.text = firstStop.uppercased()
        headerInfo.rightLabel.text = "\(Int(getOn.travelTime/60)) min".uppercased()
    }
    
    private func addSubviews() {
        tileView.addSubview(headerInfo)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Text.self
        headerInfo.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        tileView.autoPinEdge(.bottom, to: .bottom, of: headerInfo, withOffset: insets.bottom)
    }
    
    let headerInfo = BasicHeaderInfoView.newAutoLayout()
}
