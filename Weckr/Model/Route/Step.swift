//
//  Step.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class Step: Object {
    @objc dynamic var distance: Int = 0
    @objc dynamic var duration: Int = 0
    @objc dynamic var maneuver: String!
    @objc dynamic var transitDetails: TransitDetails?
}
