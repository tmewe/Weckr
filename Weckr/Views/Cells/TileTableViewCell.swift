//
//  File.swift
//  Weckr
//
//  Created by Tim Mewe on 12.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class TileTableViewCell: UITableViewCell, Reusable {
    let tileView: UIView = {
        let view = TileView(frame: CGRect.zero)
        view.clipsToBounds = false
        return view
    }()
    
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
    
    private func addSubviews() {
        contentView.addSubview(tileView)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Tile.self
        tileView.autoPinEdgesToSuperviewEdges(with: .init(top: insets.top,
                                                          left: insets.left,
                                                          bottom: insets.bottom,
                                                          right: insets.right))
    }
}
