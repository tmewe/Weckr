//
//  CalendarError.swift
//  Weckr
//
//  Created by Tim Mewe on 09.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation

enum CalendarError: AppError {
    case noEvents
    case undefined
    
    var localizedTitle: String {
        switch self {
        case .noEvents:
            return Strings.Error.Calendar.noEventsTitle
        case .undefined:
            return Strings.Error.undefinedTitle
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .noEvents:
            return Strings.Error.Calendar.noEventsMessage
        case .undefined:
            return Strings.Error.undefinedMessage
        }
    }
}
