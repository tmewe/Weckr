//
//  GeocodingService.swift
//  Weckr
//
//  Created by Tim Lehmann on 17.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RealmSwift

protocol GeocodingServiceType{
    func geocode(_ entry: CalendarEntry, realmService: RealmServiceType) throws -> Observable<GeoCoordinate>
}

class GeocodingService: GeocodingServiceType {
    
    func geocode(_ entry: CalendarEntry, realmService: RealmServiceType) throws -> Observable<GeoCoordinate> {
        let geocoder = CLGeocoder()

        guard entry.location.geoLocation == nil else {
            return Observable.just(entry.location.geoLocation!)
        }
        
        return geocoder.rx.geocodeAddressString(entry.address)
            .map { $0.0 }
            .catchOnNil { throw(GeocodeError.noMatch) }
            .catchOnEmpty { throw(GeocodeError.noMatch) }
            .map { $0.first! }
            .map { $0.location! }
            .map(GeoCoordinate.init)
    }
}
