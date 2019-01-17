//
//  Geocoding.swift
//  Weckr
//
//  Created by Tim Lehmann on 17.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import CoreLocation


class Geocoding {
    
    var coordinates: CLLocationCoordinate2D
    var name: String?
    var formattedAddress: String?
    var boundNorthEast: CLLocationCoordinate2D?
    var boundSouthWest: CLLocationCoordinate2D?
    
    init(coordinates: CLLocationCoordinate2D) {
        self.coordinates = coordinates
    }
    
}
