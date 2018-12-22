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
    
    func configure(with route: Route) {
//        let formattedTime = Date(timeIntervalSinceReferenceDate: time).toFormat("HH:mm")
        infoView.titleLabel.text = "TRAVEL"
        infoView.timeLabel.text = "24 MIN"
        infoView.infoLabel.text = "Leave at 08:01"
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
