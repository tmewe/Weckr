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

extension Date: Strideable {
    public func advanced(by n: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: n, to: self) ?? self
    }
    
    public func distance(to other: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: other, to: self).day ?? 0
    }
}
