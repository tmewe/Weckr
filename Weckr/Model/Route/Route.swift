//
//  Route.swift
//  Weckr
//
//  Created by admin on 09.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//
import Foundation
import RealmSwift

class Route: Object {
    let legs = List<Leg>()
}
