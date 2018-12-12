//
//  TitleTimeTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 12.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class TitleTimeTableViewCell: TileTableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addSubviews() {
        tileView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timeLabel)
    }
    
    private func setupConstraints() {
        stackView.autoPinEdgesToSuperviewEdges(
            with:UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15),
            excludingEdge: .bottom)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = .left
        label.text = "MORNING ROUTINE"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        label.textColor = .white
        label.textAlignment = .right
        label.text = "30 MIN"
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView.newAutoLayout()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
}
