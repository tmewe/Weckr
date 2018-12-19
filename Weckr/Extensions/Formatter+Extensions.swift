//
//  Formatter+Extensions.swift
//  Weckr
//
//  Created by Tim Mewe on 25.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

extension Formatter {
    struct Date {
        static let xsDateTime: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return formatter
        }()
    }
}
