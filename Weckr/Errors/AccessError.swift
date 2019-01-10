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
    
    var localizedMessage: String {
        switch self {
        case .calendar:
            return "calendar"
        case .location:
            return "location"
        case .notification:
            return "notification"
        default:
            return "undefinded"
        }
    }
}
