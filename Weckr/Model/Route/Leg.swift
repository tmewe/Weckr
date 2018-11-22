//
//  Leg.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class Leg: Object {
    @objc dynamic var start: Waypoint!
    @objc dynamic var end: Waypoint!
    @objc dynamic var lenght: Double = 0.0 //meters
    @objc dynamic var travelTime: Double = 0.0 //seconds
    @objc dynamic var trafficTime: Double = 0.0 //seconds
    @objc dynamic var summary: RouteSummary!
    let maneuvers = List<Maneuver>()
}
