//
//  AlarmTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 05.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit
import SwiftDate

class AlarmTableViewCell: UITableViewCell, Reusable {
    
    let dateLabel: UILabel = {
       let label = UILabel.newAutoLayout()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 48, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with date:Date) {
        let regionalDate = DateInRegion(date, region: Region.current)
        dateLabel.text = regionalDate.toFormat("HH:mm")
    }
    
    private func addSubviews() {
        contentView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        dateLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40))
    }

}
