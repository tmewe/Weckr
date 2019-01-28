//
//  GeocodeError.swift
//  Weckr
//
//  Created by Tim Lehmann on 17.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation

enum GeocodeError: AppError {
    case noMatch
    
    var localizedTitle: String {
        switch self {
        case .noMatch:
            return Strings.Error.GeoCoding.noMatchTitle
        }
    }
    
    var localizedMessage: String {
        switch self {
        case .noMatch:
            return Strings.Error.GeoCoding.noMatchMessage
        }
    }
}
