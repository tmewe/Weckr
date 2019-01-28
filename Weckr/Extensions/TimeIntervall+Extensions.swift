//
//  TimeIntervall+Extensions.swift
//  Weckr
//
//  Created by Tim Mewe on 12.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

extension TimeInterval {
    
    var timeSpan: String {
        if (self < 60) { return "" }
        return Formatter.TimeInterval.timeSpan.string(from: self)!
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: ".", with: "")
    }
    
    func toHoursMinutes() -> (Int, Int) {
        return (Int(self / 3600), Int((self.truncatingRemainder(dividingBy: 3600)) / 60))
    }
}
