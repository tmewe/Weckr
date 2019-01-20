//
//  Waypoint.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class Waypoint: Object, Decodable {
    dynamic var id: String!
    dynamic var position: GeoCoordinate!
    dynamic var label: String!
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "linkId"
        case position = "originalPosition"
        case label = "label"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        position = try container.decode(GeoCoordinate.self, forKey: .position)
        label = try container.decode(String.self, forKey: .label)
        
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
