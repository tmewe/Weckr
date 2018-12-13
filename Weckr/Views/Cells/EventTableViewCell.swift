//
//  EventTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewCell: TileTableViewCell {
    var gradientColor = (UIColor.morningRoutineCellLeft.cgColor, UIColor.morningRoutineCellRight.cgColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = (UIColor.eventCellLeft.cgColor, UIColor.eventCellRight.cgColor)

        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with title: String, event: CalendarEntry) {
        infoView.titleLabel.text = title
        infoView.timeLabel.text =  "1 H 15 MIN"
        infoView.infoLabel.text = event.title
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
    
    let locationLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.subTitle, weight: .semibold)
        label.textColor = .white
        label.alpha = 0.7
        label.text = "Geschw.-Scholl-Platz 1"
        return label
    }()
    
    let timespanLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.timespan, weight: .semibold)
        label.textAlignment = .right
        label.textColor = .white
        label.alpha = 0.7
        label.text = "08:45 - 10:00"
        return label
    }()
    
    let infoView: BasicInfoView = {
        let view = BasicInfoView.newAutoLayout()
        return view
    }()
}
