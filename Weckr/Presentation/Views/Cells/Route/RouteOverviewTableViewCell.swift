//
//  RouteCell.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import FoldingCell
import UIKit
import SwiftDate

class RouteOverviewTableViewCell: TileTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = (UIColor.routeCellLeft.cgColor, UIColor.routeCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with route: Route, leaveDate: Date) {
//        let formattedTime = Date(timeIntervalSinceReferenceDate: time).toFormat("HH:mm")
        
        var duration = Int(route.summary.trafficTime/60)
        if duration == 0 {
            duration = Int(route.summary.travelTime/60)
        }
        
        let regionalDate = DateInRegion(leaveDate, region: Region.current)
        let dateText = regionalDate.toFormat("HH:mm")
                
        infoView.headerInfo.leftLabel.text = "TRAVEL"
        infoView.headerInfo.rightLabel.text = "\(Int(route.summary.travelTime/60)) min".uppercased()
        infoView.infoLabel.text = "Leave at " + dateText
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
