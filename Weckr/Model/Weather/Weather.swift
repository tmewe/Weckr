//
//  Weather.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

@objcMembers class Weather: Object, Decodable {
    dynamic var date: Int = 0
    dynamic var temperature: Double = 0.0
    dynamic var humidity: Double = 0.0
    dynamic var rainAmount: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main
        case rain
    }
    
    enum MainCodingKeys: String, CodingKey {
        case temperature = "temp"
        case humidity = "humidity"
    }
    
    enum RainCodingKeys: String, CodingKey {
        case rainAmount = "3h"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mainContainer = try container.nestedContainer(keyedBy: MainCodingKeys.self, forKey: .main)
        let rainContainer = try? container.nestedContainer(keyedBy: RainCodingKeys.self, forKey: .rain)
        
        date = try container.decode(Int.self, forKey: .date)
        temperature = try mainContainer.decode(Double.self, forKey: .temperature)
        humidity = try mainContainer.decode(Double.self, forKey: .humidity)
        rainAmount = try rainContainer?.decodeIfPresent(Double.self, forKey: .rainAmount) ?? 0.0
        
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
