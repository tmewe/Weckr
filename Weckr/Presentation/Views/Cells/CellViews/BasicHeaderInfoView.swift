//
//  BasicHeaderInfoView.swift
//  Weckr
//
//  Created by Tim Mewe on 22.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class BasicHeaderInfoView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupViews() {
        stackView.addArrangedSubview(leftLabel)
        stackView.addArrangedSubview(rightLabel)
        addSubview(stackView)
    }
    
    private func setupConstraints() {
        stackView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }
    
    let leftLabel = SmallLabel.newAutoLayout()
    let rightLabel: SmallLabel = {
        let label = SmallLabel.newAutoLayout()
        label.textAlignment = .right
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView.newAutoLayout()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        stack.distribution = .fillProportionally
        return stack
    }()
}
