//
//  UIApplication+Extensions.swift
//  Weckr
//
//  Created by Tim Lehmann on 09.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
