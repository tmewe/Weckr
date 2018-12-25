//
//  CalendarEditView.swift
//  Weckr
//
//  Created by Tim Mewe on 25.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class CalendarEditView: UIView, CalendarEditViewProtocol, BlurBackgroundDisplayable {
    var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    var blurEffectView = UIVisualEffectView.newAutoLayout()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setupBlur(on: blurEffectView, withStyle: .dark)
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.autoPinEdgesToSuperviewSafeArea()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
