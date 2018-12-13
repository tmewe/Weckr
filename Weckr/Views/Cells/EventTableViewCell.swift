//
//  EventTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewCell: TitleTimeTableViewCell {
    var gradientColor = (UIColor.morningRoutineLeft.cgColor, UIColor.morningRoutineRight.cgColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with event: CalendarEntry) {
        titleLabel.text = "FIRST EVENT"
        timeLabel.text =  "1 H 15 MIN"
        countLabel.text = "Meeting with colleagues"
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return super.awakeAfter(using: aDecoder)
    }
    
    private func addSubviews() {
        tileView.addSubview(countLabel)
    }
    
    private func setupConstraints() {
        countLabel.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 10)
        countLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 15, bottom: 1, right: 15), excludingEdge: .top)
        tileView.autoPinEdge(.bottom, to: .bottom, of: countLabel, withOffset: 10)
    }
    
    let countLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "30 min"
        return label
    }()
}
