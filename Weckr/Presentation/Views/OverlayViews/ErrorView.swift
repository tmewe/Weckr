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
    func setError(_ error: AppError)
}

class ErrorView: UIView, BlurBackgroundDisplayable, ErrorProtocol {
    
    var blurEffectView = UIVisualEffectView.newAutoLayout()
    
    init() {
        super.init(frame: CGRect.zero)
        setupView()
        setupConstraints()
    }
    
    func setError(_ error: AppError) {
        titleLabel.text = error.localizedTitle
        messageLabel.text = error.localizedMessage
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        setupBlur(on: blurEffectView, withStyle: .dark)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Error.self
        titleLabel.autoPinEdgesToSuperviewSafeArea(with: UIEdgeInsets(top: insets.titleTop, left: insets.left, bottom: 0, right: insets.right), excludingEdge: .bottom)
        messageLabel.autoPinEdge(.left, to: .left, of: self, withOffset: insets.left)
        messageLabel.autoPinEdge(.right, to: .right, of: self, withOffset: -insets.right)
        messageLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: insets.messageTop)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleLabel: UILabel = {
       let label = UILabel.newAutoLayout()
        label.textColor = .error
        label.font = UIFont.systemFont(ofSize: Font.Size.Overlay.errorTitle, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.Overlay.errorMessage, weight: .light)
        label.textColor = .textColor
        label.numberOfLines = 0
        return label
    }()
}
