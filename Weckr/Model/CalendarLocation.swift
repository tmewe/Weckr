//
//  CalendarLocation.swift
//  Weckr
//
//  Created by Tim Mewe on 21.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

class CalendarLocation: Object {
    @objc dynamic var address: String!
    @objc dynamic var geoLocation: GeoCoordinate?
    
    override public class func primaryKey() -> String? {
        return "address"
    }
    
    convenience init(address: String, geoLocation: GeoCoordinate?) {
        self.init()
        self.address = address
        self.geoLocation = geoLocation
    }
    
    convenience init(location: EKStructuredLocation) {
        self.init()
        self.address = location.title
        guard let geoLocation = location.geoLocation else { return }
        self.geoLocation = GeoCoordinate(location: geoLocation)
    }
}
