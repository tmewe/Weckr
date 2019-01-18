//
//  CalendarEditTitleTableViewCell.swift
//  Weckr
//
//  Created by Tim Lehmann on 18.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class CalendarEditTitleTableViewCell: UITableViewCell, Reusable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK: Needed so that the cell doesn't have implicit height of 44.0
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.autoresizingMask = UIView.AutoresizingMask.flexibleHeight
    }
        
    func configure(with text:String, coloredPart: String) {
        topLabel.setTextWithColoredPart(text: text, coloredText: coloredPart, textColor: UIColor.white, coloredColor: UIColor.walkthroughGreenAccent)
    }

    
    private func addSubviews() {
        contentView.addSubview(topLabel)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Edit.self
        topLabel.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0,
                                                                  left: insets.titleLeft,
                                                                  bottom: insets.spacing,
                                                                  right: insets.titleLeft))
    }
    
    var topLabel: UILabel = {
        let label = UILabel.newAutoLayout()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: Font.Size.Walkthorugh.title, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
}
