//
//  RouteCarTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class RouteCarTableViewCell: TileTableViewCell, BasicInfoSubtitleDisplayable {
    
    typealias Configuration = Route
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = (UIColor.routeCellLeft.cgColor, UIColor.routeCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with configuration: Route) {
        let distance = configuration.summary!.distance/1000
        
        infoView.headerInfoView.leftLabel.text = Strings.Directions.drive.uppercased()
        infoView.infoLabel.text = configuration.legs.last!.end.label
        distanceLabel.text = "\(distance) kilometers".lowercased()
    }
    
    var infoView: BasicInfoView = {
        let view = BasicInfoView.newAutoLayout()
        return view
    }()
    
    var distanceLabel = SmallLabel.newAutoLayout()
}
