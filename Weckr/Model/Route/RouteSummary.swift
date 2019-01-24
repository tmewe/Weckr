//
//  RouteSummary.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class RouteSummary: Object, Decodable {
    dynamic var distance: Int = 0 //meters
    dynamic var travelTime: Int = 0 //seconds
    dynamic var trafficTime: Int = 0 //seconds
    dynamic var text: String!
    
    override public class func primaryKey() -> String? {
        return "distance"
    }
    
    enum CodingKeys: String, CodingKey {
        case distance = "distance"
        case travelTime = "travelTime"
        case trafficTime = "trafficTime"
        case text = "text"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        distance = try container.decode(Int.self, forKey: .distance)
        travelTime = try container.decode(Int.self, forKey: .travelTime)
        trafficTime = try container.decodeIfPresent(Int.self, forKey: .trafficTime) ?? 0
        if trafficTime < 1 { trafficTime = travelTime }
        text = try container.decode(String.self, forKey: .text)
        
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
