//
//  MorningRoutineTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 12.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MorningRoutineTableViewCell: TitleTimeTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = (UIColor.morningRoutineLeft.cgColor, UIColor.morningRoutineRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with time: TimeInterval) {
        let formattedTime = Date(timeIntervalSinceReferenceDate: time).toFormat("HH:mm")
        titleLabel.text = "MORNING ROUTINE"
        timeLabel.text = formattedTime + " MIN"
        countLabel.text = formattedTime + " min left"
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return super.awakeAfter(using: aDecoder)
    }
    
    private func addSubviews() {
        tileView.addSubview(countLabel)
    }
    
    private func setupConstraints() {
        countLabel.autoPinEdge(.top, to: .bottom, of: stackView, withOffset: 10)
        countLabel.autoPinEdge(.left, to: .left, of: tileView, withOffset: 15)
        countLabel.autoPinEdge(.right, to: .right, of: tileView, withOffset: 15)
        tileView.autoPinEdge(.bottom, to: .bottom, of: countLabel, withOffset: 10)
    }
    
    let countLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        label.textColor = .white
        label.text = "30 min"
        return label
    }()
}
