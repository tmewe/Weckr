//
//  Waypoint.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class Waypoint: Object {
    @objc dynamic var position: GeoCoordinate!
    @objc dynamic var label: String!
}
