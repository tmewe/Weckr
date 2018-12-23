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
    case headSouthEast = "Head southeast"
    case headSouthWest = "Head southwest"
    case headNorth = "Head north"
    case headNorthWest = "Head northwest"
    case headNorthEast = "Head northeast"
    case headEast = "Head east"
    case headWest = "Head west"
    case turnLeft = "Turn left"
    case turnRight = "Turn right"
    case continueStraight = "Continue straight"
    case roundabout = "Walk right" //around the roundabout
    
    var localized: String {
        switch self {
        case .headNorth:
            return "direction.north".localized()
        case .headNorthEast:
            return "direction.northEast".localized()
        case .headNorthWest:
            return "direction.northWest".localized()
        case .headSouth:
            return "direction.south".localized()
        case .headSouthEast:
            return "direction.southEast".localized()
        case .headSouthWest:
            return "direction.southWest".localized()
        case .headEast:
            return "direction.east".localized()
        case .headWest:
            return "direction.west".localized()
        case .turnLeft:
            return "direction.left".localized()
        case .turnRight:
            return "direction.right".localized()
        case .continueStraight:
            return "direction.continueStraight".localized()
        case .roundabout:
            return "direction.roundabout".localized()
        }
    }
}
