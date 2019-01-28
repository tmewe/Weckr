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
    case slightlyLeft = "Turn slightly left"
    case slightlyRight = "Turn slightly right"
    case continueStraight = "Continue straight"
    case takeStreetRight = "Take the street on the right,"
    case takeStreetLeft = "Take the street on the left,"
    case roundabout = "Walk right around" // the roundabout
    case walkTo = "Walk to"
    
    var localized: String {
        let strings = Strings.Directions.self
        switch self {
        case .headNorth:
            return strings.north
        case .headNorthEast:
            return strings.northEast
        case .headNorthWest:
            return strings.northWest
        case .headSouth:
            return strings.south
        case .headSouthEast:
            return strings.southEast
        case .headSouthWest:
            return strings.southWest
        case .headEast:
            return strings.east
        case .headWest:
            return strings.west
        case .turnLeft:
            return strings.left
        case .turnRight:
            return strings.right
        case .slightlyLeft:
            return strings.slightlyLeft
        case .slightlyRight:
            return strings.slightlyRight
        case .takeStreetRight:
            return strings.takeStreetRight
        case .takeStreetLeft:
            return strings.takeStreetLeft
        case .continueStraight:
            return strings.straight
        case .roundabout:
            return strings.roundabout
        case .walkTo:
            return strings.walkTo
        }
    }
}
