//
//  TransitLine.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class TransitLine: Object {
    @objc dynamic var name: String!
    @objc dynamic var shortName: String!
    @objc dynamic var color: String!
    @objc dynamic var icon: String!
    @objc dynamic var vehicle: TransitVehicle!
}
