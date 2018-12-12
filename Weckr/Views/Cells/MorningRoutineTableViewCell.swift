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

class MorningRoutineTableViewCell: TileTableViewCell {
    
    var gradientColor = (UIColor.morningRoutineLeft.cgColor, UIColor.morningRoutineRight.cgColor)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with time: TimeInterval) {
        timeLabel.text = Date(timeIntervalSinceReferenceDate: time).toFormat("HH:mm") + " min"
    }
    
    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        return super.awakeAfter(using: aDecoder)
    }
    
    private func addSubviews() {
        tileView.addSubview(titleLabel)
        tileView.addSubview(timeLabel)
    }
    
    private func setupConstraints() {
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 15), excludingEdge: .bottom)
        timeLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 10)
        timeLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0, left: 15, bottom: 1, right: 15), excludingEdge: .top)
        tileView.autoPinEdge(.bottom, to: .bottom, of: timeLabel, withOffset: 10)
        
        tileView.setGradientForCell(colors: (UIColor.morningRoutineLeft.cgColor,
                                             UIColor.morningRoutineRight.cgColor))
    }
    
    let titleLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = .white
        label.text = "MORNING ROUTINE"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 28.0, weight: .bold)
        label.textColor = .white
        label.text = "30 min"
        return label
    }()
}
