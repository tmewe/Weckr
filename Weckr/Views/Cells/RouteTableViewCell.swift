//
//  RouteCell.swift
//  Weckr
//
//  Created by Tim Mewe on 13.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import FoldingCell
import UIKit

class RouteTableViewCell: FoldingCell, Reusable {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        gradient = (UIColor.morningRoutineCellLeft.cgColor, UIColor.morningRoutineCellRight.cgColor)
        backgroundColor = .clear
        
        addSubviews()
        setupConstraints()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with route: Route) {
    }
    
    private func addSubviews() {
        addSubview(foreground)
        addSubview(container)
        foregroundView = foreground
        containerView = container
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Tile.self
        foregroundViewTop = foregroundView.autoPinEdge(.top, to: .top, of: self, withOffset: insets.top)
        foregroundView.autoSetDimension(.height, toSize: 100)
        foregroundView.autoPinEdge(.left, to: .left, of: self, withOffset: insets.left)
        foregroundView.autoPinEdge(.right, to: .right, of: self, withOffset: -insets.right)
        
        containerViewTop = contentView.autoPinEdge(.top, to: .top, of: self, withOffset: 120)
        
//        let insets = Constraints.Main.Text.self
//        infoView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: insets.top,
//                                                                 left: insets.left,
//                                                                 bottom: insets.bottom,
//                                                                 right: insets.right),
//                                              excludingEdge: .bottom)
//        tileView.autoPinEdge(.bottom, to: .bottom, of: infoView, withOffset: insets.bottom)
    }
    
    let foreground: RotatedView = {
        let rotated = RotatedView.newAutoLayout()
        rotated.backgroundColor = .clear
        let view = TileView.newAutoLayout()
        view.backgroundColor = .blue
        rotated.addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
        return rotated
    }()
    
    let container: RotatedView = {
        let rotated = RotatedView.newAutoLayout()
        let view = TileView.newAutoLayout()
        view.backgroundColor = .red
        rotated.addSubview(view)
        return rotated
    }()
    
    let infoView: BasicInfoView = {
        let view = BasicInfoView.newAutoLayout()
        return view
    }()
}
