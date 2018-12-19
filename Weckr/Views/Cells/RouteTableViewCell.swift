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
        
        backViewColor = .red
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configure(with route: Route) {
        addSubviews()

        let container = createContainerView(maneuvers: route.legs.first!.maneuvers.toArray())
        contentView.addSubview(container)
        containerView = container
        
        setupConstraints()
        commonInit()
    }
    
    private func addSubviews() {
        contentView.addSubview(foreground)
        foregroundView = foreground
    }
    
    private func setupConstraints() {
        let insets = Constraints.Main.Tile.self
        
        contentView.autoPinEdge(.left, to: .left, of: self, withOffset: insets.left)
        contentView.autoPinEdge(.right, to: .right, of: self, withOffset: -insets.right)
        
        foregroundViewTop = foregroundView.autoPinEdge(.top, to: .top, of: contentView, withOffset: insets.top)
        foregroundView.autoSetDimension(.height, toSize: 100)
        foregroundView.autoPinEdge(.left, to: .left, of: contentView)
        foregroundView.autoPinEdge(.right, to: .right, of: contentView)
        
        containerViewTop = containerView.autoPinEdge(.top, to: .top, of: contentView, withOffset: 150)
        containerView.autoPinEdge(.left, to: .left, of: contentView)
        containerView.autoPinEdge(.right, to: .right, of: contentView)
    }
    
    override func animationDuration(_ itemIndex:NSInteger, type:AnimationType) -> TimeInterval {
        let durations = (1...itemCount).map { _ in 0.3 } // timing animation for each view
        return durations[itemIndex]
    }
    
    let rowHeight = 100
    
    private func createContainerView(maneuvers: [Maneuver]) -> UIView {
        let count = maneuvers.count
        itemCount = count
        
        let content = UIView.newAutoLayout()
        content.backgroundColor = .clear
        
        for i in 0...count-1 {
            let view = TileView.newAutoLayout()
            content.addSubview(view)

//            let offset = i == 0 ? 10 : (i * (rowHeight + 20) + 10

            view.backgroundColor = .red
            view.autoSetDimension(.height, toSize: CGFloat(rowHeight))
            view.autoPinEdge(.left, to: .left, of: content)
            view.autoPinEdge(.right, to: .right, of: content)
            view.autoPinEdge(.top, to: .top, of: content, withOffset: CGFloat((i * (rowHeight + 20))))
            
            if (i == count - 1) {
                content.autoPinEdge(.bottom, to: .bottom, of: view, withOffset: 10)
            }
        }
        
        return content
    }
    
    let foreground: RotatedView = {
        let rotated = RotatedView.newAutoLayout()
        rotated.backgroundColor = .clear
        let view = TileView.newAutoLayout()
        view.backgroundColor = .blue
        rotated.addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
        rotated.layer.cornerRadius = view.layer.cornerRadius
        return rotated
    }()
    
    let container: RotatedView = {
        let rotated = RotatedView.newAutoLayout()
        rotated.backgroundColor = .clear
        let view = TileView.newAutoLayout()
        view.backgroundColor = .red
        rotated.addSubview(view)
        view.autoPinEdgesToSuperviewEdges()
        return rotated
    }()
    
    let infoView: BasicInfoView = {
        let view = BasicInfoView.newAutoLayout()
        return view
    }()
}
