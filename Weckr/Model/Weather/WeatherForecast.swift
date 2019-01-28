//
//  WeatherForecast.swift
//  Weckr
//
//  Created by Tim Mewe on 23.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class WeatherForecast: Object, Decodable {
    let weathers = List<Weather>()
    dynamic var cityName: String!
    
    override public class func primaryKey() -> String? {
        return "cityName"
    }
    
    enum CodingKeys: String, CodingKey {
        case weathers = "list"
        case city
    }
    
    enum CityCodingKeys: String, CodingKey {
        case cityName = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let cityContainer = try container.nestedContainer(keyedBy: CityCodingKeys.self, forKey: .city)
        let weathersList = try container.decode([Weather].self, forKey: .weathers)
        weathers.append(objectsIn: weathersList)
        cityName = try cityContainer.decode(String.self, forKey: .cityName)
        
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
