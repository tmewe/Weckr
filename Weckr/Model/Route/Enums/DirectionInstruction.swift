//
//  DirectionInstruction.swift
//  Weckr
//
//  Created by Tim Mewe on 22.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

enum DirectionInstruction: String {
    case headSouth = "Head south"
    case headNorth = "Head north"
    case headEast = "Head east"
    case headWest = "Head west"
    case turnLeft = "Turn left"
    case turnRight = "Turn right"
    
    var localized: String {
        switch self {
        case .headNorth:
            return "direction.north".localized()
        case .headSouth:
            return "direction.south".localized()
        case .headEast:
            return "direction.east".localized()
        case .headWest:
            return "direction.west".localized()
        case .turnLeft:
            return "direction.left".localized()
        case .turnRight:
            return "direction.right".localized()
        }
    }
}
