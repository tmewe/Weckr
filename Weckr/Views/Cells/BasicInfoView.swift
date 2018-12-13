//
//  BasicInfoView.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class BasicInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(timeLabel)
        addSubview(stackView)
        addSubview(infoLabel)
    }
    
    private func setupConstraints() {
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        infoLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
        infoLabel.autoPinEdge(.top, to: .bottom, of: stackView,
                              withOffset: Constraints.Main.Text.largeSpacing)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.title, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .left
        label.alpha = 0.7
        label.text = "MORNING ROUTINE"
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.time, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .right
        label.alpha = 0.7
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
    
    let infoLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TileCell.info, weight: .bold)
        label.textColor = .white
        label.text = "30 min"
        return label
    }()
}
