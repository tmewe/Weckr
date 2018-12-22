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
    
    let titleLabel = SmallLabel.newAutoLayout()
    let timeLabel = SmallLabel.newAutoLayout()
    let infoLabel = LargeLabel.newAutoLayout()
    let stackView: UIStackView = {
        let stack = UIStackView.newAutoLayout()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .center
        return stack
    }()
    
}
