//
//  VehicleSegmentedControl+Extension.swift
//  Weckr
//
//  Created by admin on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: VehicleSegmentedControl {
    
    /// Reactive wrapper for `selectedSegmentIndex` property.
    var selectedSegmentIndex: ControlProperty<Int> {
        return value
    }
    
    /// Reactive wrapper for `selectedSegmentIndex` property.
    var value: ControlProperty<Int> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { segmentedControl in
                segmentedControl.selectedIndex
        }, setter: { segmentedControl, value in
            segmentedControl.selectedIndex = value
        }
        )
    }
}
