//
//  TransitVehicle.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class TransitVehicle: Object {
    @objc dynamic var name: String!
    @objc dynamic var type: String!
    @objc dynamic var icon: String!
}
