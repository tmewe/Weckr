//
//  AlarmTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 05.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell, Reusable {
    
    let dateLabel: UILabel = {
       let label = UILabel.newAutoLayout()
        label.text = "07:59"
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
    
    private func addSubviews() {
        contentView.addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        dateLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40))
    }

}
