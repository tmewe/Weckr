//
//  CeoCoordinate.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import CoreLocation

@objcMembers public class GeoCoordinate: Object, Decodable, RealmOptionalType {
    dynamic var latitude: Double = 0.0
    dynamic var longitude: Double = 0.0
    dynamic var compoundKey: String!
    
    enum CodingKeys: String, CodingKey {
        case latitude = "latitude"
        case longitude = "longitude"
    }
    
    override public class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(lat: Double, long: Double) {
        self.init()
        latitude = lat
        longitude = long
        compoundKey = "\(latitude),\(longitude)"
    }
    
    convenience init(location: CLLocation) {
        self.init()
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        compoundKey = "\(latitude),\(longitude)"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        compoundKey = "\(latitude),\(longitude)"

        super.init()
    }
    
    func toString() -> String {
        return "\(latitude),\(longitude)"
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
