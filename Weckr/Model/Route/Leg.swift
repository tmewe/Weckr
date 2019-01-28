//
//  Leg.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class Leg: Object, Decodable {
    dynamic var start: Waypoint!
    dynamic var end: Waypoint!
    dynamic var length: Double = 0.0 //meters
    dynamic var travelTime: Double = 0.0 //seconds
    let maneuvers = List<Maneuver>()
    
    enum CodingKeys: String, CodingKey {
        case start = "start"
        case end = "end"
        case length = "length"
        case travelTime = "travelTime"
        case maneuvers = "maneuver"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        start = try container.decode(Waypoint.self, forKey: .start)
        end = try container.decode(Waypoint.self, forKey: .end)
        length = try container.decode(Double.self, forKey: .length)
        travelTime = try container.decode(Double.self, forKey: .travelTime)
        let maneuverList = try container.decode([Maneuver].self, forKey: .maneuvers)
        maneuvers.append(objectsIn: maneuverList)
        
        super.init()
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}
