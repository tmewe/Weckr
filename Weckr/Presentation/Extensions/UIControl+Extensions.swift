//
//  UIControl+Extensions.swift
//  Weckr
//
//  Created by admin on 19.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

extension Reactive where Base: UIControl {

    /// This is a separate method to better communicate to public consumers that
    /// an `editingEvent` needs to fire for control property to be updated.
    internal func controlPropertyWithDefaultEvents<T>(
        editingEvents: UIControl.Event = [.allEditingEvents, .valueChanged],
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> ()
        ) -> ControlProperty<T> {
        return controlProperty(
            editingEvents: editingEvents,
            getter: getter,
            setter: setter
        )
    }

}
