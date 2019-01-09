//
//  ErrorView.swift
//  Weckr
//
//  Created by Tim Mewe on 09.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

protocol ErrorProtocol {
    
}

class ErrorView: UIView, ErrorProtocol {
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(messgeLabel)
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        backgroundColor = .black
        alpha = 0.7
    }
    
    private func setupConstraints() {
        messgeLabel.autoCenterInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messgeLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "fjasklödfjask fklsajf alksd jfklsd jföklsdj föasdfjaö"
        label.textColor = .white
        return label
    }()
}
