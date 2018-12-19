//
//  AccessError.swift
//  Weckr
//
//  Created by Tim Mewe on 28.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

enum AccessError: Error {
    case calendar
    case location
    case notification
}
