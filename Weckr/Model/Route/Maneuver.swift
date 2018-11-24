//
//  Maneuver.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class Maneuver: Object, Decodable {
    dynamic var instruction: String!
    dynamic var travelTime: Double = 0.0 //seconds
    dynamic var length: Double = 0.0 //meters
    dynamic var lineId: String?
    
    enum CodingKeys: String, CodingKey {
        case instruction = "instruction"
        case travelTime = "travelTime"
        case length = "length"
        case lineId = "line"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        instruction = try container.decode(String.self, forKey: .instruction)
        travelTime = try container.decode(Double.self, forKey: .travelTime)
        length = try container.decode(Double.self, forKey: .length)
        lineId = try container.decodeIfPresent(String.self, forKey: .lineId)
        
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
