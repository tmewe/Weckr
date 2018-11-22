//
//  Maneuver.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class Maneuver: Object {
    @objc dynamic var instruction: String!
    @objc dynamic var travelTime: Double = 0.0 //seconds
    @objc dynamic var length: Double = 0.0 //meters
}
