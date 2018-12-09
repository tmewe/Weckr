//
//  AlarmTableHeaderView.swift
//  Weckr
//
//  Created by Tim Mewe on 09.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class AlarmTableHeaderView: UIView {
    private var safeArea = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11.0, *) {
            safeArea = safeAreaInsets
            setupConstraints()
        }
    }
    
    private func setupConstraints() {
        titleLabel.autoPinEdge(.right, to: .right, of: self)
        titleLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: Constraints.Main.Insets.regular)
        titleLabel.autoPinEdge(.bottom, to: .bottom, of: self, withOffset: -Constraints.Main.Insets.medium)
        titleLabel.autoPinEdge(.left, to: .left, of: self, withOffset: 15)
    }
    
    let titleLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
        label.textColor = .white
        label.text = "Tomorrow"
        return label
    }()
}
