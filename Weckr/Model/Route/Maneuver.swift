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
    dynamic var id: String!
    dynamic var instruction: String!
    dynamic var travelTime: Double = 0.0 //seconds
    dynamic var length: Double = 0.0 //meters
    dynamic var lineId: String?
    dynamic var rawTransportType: String!
    
    var transportType: ManeuverTransportType {
        get {
            guard let type = ManeuverTransportType(rawValue: rawTransportType)
                else { return .privateTransport }
            return type
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case instruction = "instruction"
        case travelTime = "travelTime"
        case length = "length"
        case lineId = "line"
        case rawTransportType = "_type"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        instruction = try container.decode(String.self, forKey: .instruction)
        travelTime = try container.decode(Double.self, forKey: .travelTime)
        length = try container.decode(Double.self, forKey: .length)
        lineId = try container.decodeIfPresent(String.self, forKey: .lineId)
        rawTransportType = try container.decode(String.self, forKey: .rawTransportType)
        
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
