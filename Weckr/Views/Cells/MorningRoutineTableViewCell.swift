//
//  MorningRoutineTableViewCell.swift
//  Weckr
//
//  Created by Tim Mewe on 12.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MorningRoutineTableViewCell: TileTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        gradient = (UIColor.morningRoutineCellLeft.cgColor, UIColor.morningRoutineCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with time: TimeInterval) {
        let formattedTime = Date(timeIntervalSinceReferenceDate: time).toFormat("HH:mm")
        infoView.titleLabel.text = "MORNING ROUTINE"
        infoView.timeLabel.text = formattedTime + " MIN"
        infoView.infoLabel.text = formattedTime + " min left"
    }
    
    private func addSubviews() {
        tileView.addSubview(infoView)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Text.self
        infoView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
                                                                 left: insets.left,
                                                                 bottom: insets.bottom,
                                                                 right: insets.right),
                                              excludingEdge: .bottom)
        tileView.autoPinEdge(.bottom, to: .bottom, of: infoView, withOffset: insets.bottom)
    }
    
    let infoView: BasicInfoView = {
        let view = BasicInfoView.newAutoLayout()
        return view
    }()
}
