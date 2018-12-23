//
//  MorningRoutineEditView.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class MorningRoutineEditView: BaseEditView, MorningRoutineEditViewProtocol {
    
    override init() {
        super.init()
        addSubviews()
        addSubview(picker)
        picker.autoCenterInSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var picker = TimePicker()
}
