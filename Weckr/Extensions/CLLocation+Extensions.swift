//
//  CLLocation+Extensions.swift
//  Weckr
//
//  Created by Tim Mewe on 26.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocation {
    convenience init(coordinate: GeoCoordinate) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
