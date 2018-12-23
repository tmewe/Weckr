//
//  BaseEditView.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class BaseEditView: UIView, EditViewProtocol {
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var topLabel = WalkthroughTitleLabel(title: Strings.Main.Edit.morningRoutineTitle,
                                         alignment: .left)
    var button = RoundedButton(text: Strings.Main.Edit.done, gradient: nil)
}
