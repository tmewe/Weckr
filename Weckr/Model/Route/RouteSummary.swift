//
//  RouteSummary.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class RouteSummary: Object {
    @objc dynamic var distance: Int = 0 //meters
    @objc dynamic var trafficTime: Int = 0 //seconds
    @objc dynamic var text: String!
}
