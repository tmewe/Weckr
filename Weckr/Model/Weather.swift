//
//  Weather.swift
//  Weckr
//
//  Created by Tim Mewe on 14.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift

class Weather: Object {
    @objc dynamic var cityName: String!
    @objc dynamic var temperature: Int = 0
    @objc dynamic var humidity: Int = 0
    @objc dynamic var rainAmount: Double = 0.0
    @objc dynamic var icon: String!
}
