//
//  TransitLine.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class TransitLine: Object, Decodable {
    dynamic var name: String!
    dynamic var foregroundColor: String!
    dynamic var backgroundColor: String!
    dynamic var destination: String!
    dynamic var type: String!
    dynamic var id: String!
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "lineName"
        case foregroundColor = "lineForeground"
        case backgroundColor = "lineBackground"
        case destination = "destination"
        case type = "type"
        case id = "id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        foregroundColor = try container.decode(String.self, forKey: .foregroundColor)
        backgroundColor = try container.decode(String.self, forKey: .backgroundColor)
        destination = try container.decode(String.self, forKey: .destination)
        type = try container.decode(String.self, forKey: .type)
        id = try container.decode(String.self, forKey: .id)
        
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
