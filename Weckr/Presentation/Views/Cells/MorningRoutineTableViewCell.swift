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
        gradient = Gradient(left: UIColor.morningRoutineCellLeft.cgColor,
                            right: UIColor.morningRoutineCellRight.cgColor)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with time: TimeInterval) {
        let formattedTime = time.timeSpan
        infoView.headerInfoView.leftLabel.text = Strings.Cells.MorningRoutine.title.uppercased()
        infoView.headerInfoView.rightLabel.text = formattedTime.uppercased()
        infoView.infoLabel.text = Strings.Cells.MorningRoutine.timePrefix
            + formattedTime //TODO: real remaining time!
            + Strings.Cells.MorningRoutine.timeSuffix
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
