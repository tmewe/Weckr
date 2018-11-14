//
//  Leg.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class Leg: Object {
    @objc dynamic var distance: Int = 0
    @objc dynamic var duration: Int = 0
    @objc dynamic var durationInTraffic: Int = 0
    @objc dynamic var arrival: Date!
}
