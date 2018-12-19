//
//  Date+Extensions.swift
//  Weckr
//
//  Created by Tim Mewe on 25.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

extension Date {
    var xsDateTime: String {
        return Formatter.Date.xsDateTime.string(from: self)
    }
}
