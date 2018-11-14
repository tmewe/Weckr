//
//  TransitDetails.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class TransitDetails: Object {
    @objc dynamic var departureStop: String!
    @objc dynamic var arrivalStop: String!
    @objc dynamic var departure: Date!
    @objc dynamic var arrival: Date!
    @objc dynamic var headsign: String!
    @objc dynamic var stops: Int = 0
}
