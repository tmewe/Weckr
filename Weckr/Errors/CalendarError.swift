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
    
    var localizedMessage: String {
        return "yeaf"
    }
}
