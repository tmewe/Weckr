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
        addSubview(headerInfo)
        addSubview(infoLabel)
    }
    
    private func setupConstraints() {
        headerInfo.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
        infoLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
        infoLabel.autoPinEdge(.top, to: .bottom, of: headerInfo,
                              withOffset: Constraints.Main.Text.largeSpacing)
    }
    
    let headerInfo = BasicHeaderInfoView.newAutoLayout()
    let infoLabel = LargeLabel.newAutoLayout()
}
