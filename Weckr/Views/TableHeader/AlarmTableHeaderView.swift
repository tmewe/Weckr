//
//  AlarmTableHeaderView.swift
//  Weckr
//
//  Created by Tim Mewe on 09.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AlarmTableHeaderView: UIView {
    
    let disposeBag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(dateLabel)
        addSubview(titleLabel)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if #available(iOS 11.0, *) {
            setupConstraints()
        }
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Header.self
        dateLabel.autoPinEdge(toSuperviewSafeArea: .top, withInset: insets.top)
        dateLabel.autoPinEdge(.left, to: .left, of: self, withOffset: insets.left)
        dateLabel.autoPinEdge(.right, to: .right, of: self)

        titleLabel.autoPinEdge(.top, to: .bottom, of: dateLabel, withOffset: insets.spacing)
        titleLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0,
                                                                   left: insets.left,
                                                                   bottom: insets.bottom,
                                                                   right: 0),
                                                excludingEdge: .top)
    }
    
    let dateLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TableHeader.date, weight: .medium)
        label.textColor = .darkGray
        return label
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.font = UIFont.systemFont(ofSize: Font.Size.TableHeader.title, weight: .bold)
        label.textColor = .white
        label.text = "main.header.tomorrow".localized()
        return label
    }()
}
