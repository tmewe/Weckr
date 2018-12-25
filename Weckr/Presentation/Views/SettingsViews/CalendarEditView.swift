//
//  CalendarEditView.swift
//  Weckr
//
//  Created by Tim Mewe on 25.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class CalendarEditView: UIView, CalendarEditViewProtocol, BlurBackgroundDisplayable {
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var blurEffectView = UIVisualEffectView.newAutoLayout()
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupBlur(on: blurEffectView, withStyle: .dark)
        addSubview(tableView)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTableView() {
        tableView.autoPinEdgesToSuperviewSafeArea()
        tableView.registerReusableCell(EventTableViewCell.self)

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.showsVerticalScrollIndicator = false
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { cell, indexPath in
                let insets = Constraints.Main.Tile.self
                let frame = CGRect(x: insets.left, y: insets.top,
                                   width: cell.frame.width-insets.left-insets.right,
                                   height: cell.frame.height-insets.top-insets.bottom)
                
                guard let tileCell = cell as? TileTableViewCell else { return }
                guard let gradient = tileCell.gradient else { return }
                tileCell.tileView.frame = frame
                tileCell.tileView.setGradientForCell(gradient)
            })
            .disposed(by: disposeBag)
    }
}
