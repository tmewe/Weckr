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
    func setError(_ error: Error)
}

class ErrorView: UIView, ErrorProtocol {
    
    init() {
        super.init(frame: CGRect.zero)
        addSubview(messageLabel)
        setupView()
        setupConstraints()
    }
    
    func setError(_ error: Error) {
        messageLabel.text = error.localizedDescription
    }
    
    private func setupView() {
        backgroundColor = .backgroundColor
    }
    
    private func setupConstraints() {
        messageLabel.autoCenterInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var messageLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.text = "fjasklödfjask fklsajf alksd jfklsd jföklsdj föasdfjaö"
        label.textColor = .white
        return label
    }()
}
