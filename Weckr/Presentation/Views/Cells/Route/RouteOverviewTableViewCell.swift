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
import RxSwift

class RouteOverviewTableViewCell: TileTableViewCell, BasicInfoDisplayable {
    
    
    
    typealias Configuration = (Route, Date)
    
    var infoView = BasicInfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = Gradient(left: UIColor.routeCellLeft.cgColor,
                            right:UIColor.routeCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
        setupSmartInfoButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSmartInfoButton() {
        infoView.addSubview(infoButton)
        infoButton.autoPinEdge(toSuperviewEdge: .right)
        infoButton.autoPinEdge(toSuperviewEdge: .bottom)
    }
    
    
    func configure(with configuration: (Route, Date)) {
        
        let route = configuration.0
        let leaveDate = configuration.1
        
        let travelTime = TimeInterval(route.summary.travelTime)
        
        let dateText = leaveDate.timeShortDropZero
        
        infoButton.isHidden = !route.smartAdjusted
        infoView.headerInfoView.leftLabel.text = Strings.Cells.RouteOverview.title.uppercased()
        infoView.headerInfoView.rightLabel.text = travelTime.timeSpan.uppercased()
        infoView.infoLabel.text = Strings.Cells.RouteOverview.timePrefix
            + dateText
            + Strings.Cells.RouteOverview.timeSuffix
        
    }
    
    lazy var infoButton: UIButton = {
        let button = UIButton(type: .infoLight)
        button.tintColor = .white
        return button
    }()
}
