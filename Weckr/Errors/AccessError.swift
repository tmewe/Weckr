//
//  AccessError.swift
//  Weckr
//
//  Created by Tim Mewe on 28.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

enum AccessError: AppError {
    case calendar
    case location
    case notification
    
    var localizedTitle: String {
        switch self {
        case .calendar:
            return Strings.Error.Access.calendarTitle
        case .location:
            return Strings.Error.Access.locationTitle
        case .notification:
            return Strings.Error.Access.notificationTitle
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .calendar:
            return Strings.Error.Access.calendarMessage
        case .location:
            return Strings.Error.Access.locationMessage
        case .notification:
            return Strings.Error.Access.notificationMessage
        }
    }
}
