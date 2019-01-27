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
    
    enum PaddingSize {
        case normal
        case small
    }
    
    public var gradient: Gradient?
    
    var topPadding: PaddingSize { return .normal }
    var bottomPadding: PaddingSize { return .normal }

    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubview(tileView)
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Tile.self
        tileView.autoPinEdgesToSuperviewEdges(with: .init(top: topPadding == .small
                                                            ? insets.topSmall
                                                            : insets.top,
                                                          left: insets.left,
                                                          bottom: bottomPadding == .small
                                                            ? insets.bottomSmall
                                                            : insets.bottom,
                                                          right: insets.right))
    }
    
    let tileView: UIView = {
        let view = TileView.newAutoLayout()
        view.clipsToBounds = true
        return view
    }()
}
