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
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        DispatchQueue.main.async {
            self.datePickerMode = .countDownTimer
            self.countDownDuration = 1
        }
        setValue(UIColor.textColor, forKeyPath: "textColor")
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
