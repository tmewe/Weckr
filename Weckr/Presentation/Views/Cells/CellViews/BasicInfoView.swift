//
//  BasicInfoView.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class BasicInfoView: UIView, BasicHeaderInfoDisplayable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addSubviews() {
        addSubview(headerInfoView)
        addSubview(infoLabel)
    }
    
    private func setupConstraints() {
        headerInfoView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        infoLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
        infoLabel.autoPinEdge(.top, to: .bottom, of: headerInfoView,
                              withOffset: Constraints.Main.Text.largeSpacing)
    }
    
    var headerInfoView = BasicHeaderInfoView.newAutoLayout()
    let infoLabel = LargeLabel.newAutoLayout()
}
