//
//  EventTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import SwiftDate

class EventTableViewCell: TileTableViewCell, BasicInfoDisplayable {
    
    typealias Configuration = (String, CalendarEntry)
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = Gradient(left: UIColor.eventCellLeft.cgColor,
                            right:UIColor.eventCellRight.cgColor)

        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupConstraints()
    }
    
    func configure(with configuration: (String, CalendarEntry)) {
        
        let title = configuration.0.uppercased()
        let event = configuration.1
        
        //Info
        infoView.headerInfoView.leftLabel.text = title
        infoView.headerInfoView.rightLabel.text =  "1 H 15 MIN"
        infoView.infoLabel.text = event.title
        
        //Timespan
        let start = event.startDate.timeShort
        let end = event.endDate.timeShort
        timespanLabel.text = start + " - " + end
        
        //Duration
        let time: TimeInterval = TimeInterval(event.startDate.getInterval(toDate: event.endDate, component: .second))
        infoView.headerInfoView.rightLabel.text = time.timeSpan.uppercased()
        
        //Location
        locationLabel.text = event.address
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return super.awakeAfter(using: aDecoder)
    }
    
    private func addSubviews() {
        tileView.addSubview(infoView)
        tileView.addSubview(locationLabel)
        tileView.addSubview(timespanLabel)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Text.self
        infoView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        
        locationLabel.autoPinEdge(.top, to: .bottom, of: infoView, withOffset: insets.smallSpacing)
        locationLabel.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        locationLabel.autoPinEdge(.right, to: .right, of: tileView, withOffset: -insets.right)
        
        timespanLabel.autoPinEdge(.top, to: .bottom, of: locationLabel, withOffset: insets.largeSpacing)
        timespanLabel.autoPinEdge(.left, to: .left, of: tileView, withOffset: insets.left)
        timespanLabel.autoPinEdge(.right, to: .right, of: tileView, withOffset: -insets.right)
        
        tileView.autoPinEdge(.bottom, to: .bottom, of: timespanLabel, withOffset: insets.bottom)
    }
    
    var infoView = BasicInfoView()
    private let locationLabel = SmallLabel()
    private let timespanLabel: SmallLabel = {
       let label = SmallLabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.timespan, weight: .semibold)
        return label
    }()
}
