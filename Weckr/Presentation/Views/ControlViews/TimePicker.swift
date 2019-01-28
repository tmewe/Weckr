//
//  TimePicker.swift
//  Weckr
//
//  Created by Tim Mewe on 23.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

class TimePicker: UIDatePicker {
    //FIXME: - Weird behaviour at first pick
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.datePickerMode = .countDownTimer
        setValue(UIColor.textColor, forKeyPath: "textColor")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
