//
//  Route.swift
//  Weckr
//
//  Created by admin on 09.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//
import Foundation
import Realm
import RealmSwift

@objcMembers class Route: Object, Decodable {
    let legs = List<Leg>()
    let transitLines = List<TransitLine>()
    dynamic var summary: RouteSummary!
    
    enum CodingKeys: String, CodingKey {
        case legs = "leg"
        case transitLines = "publicTransportLine"
        case summary = "summary"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let legsList = try container.decode([Leg].self, forKey: CodingKeys.legs)
        legs.append(objectsIn: legsList)
        
        let transitLinesList = try container.decodeIfPresent([TransitLine].self, forKey: .transitLines) ?? []
        transitLines.append(objectsIn: transitLinesList)
        
        summary = try container.decode(RouteSummary.self, forKey: .summary)
        
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
