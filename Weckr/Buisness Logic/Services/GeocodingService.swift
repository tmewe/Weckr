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
    func geocode(_ entry: CalendarEntry) throws -> Observable<GeoCoordinate>
}

class GeocodingService: GeocodingServiceType {
    
    lazy var geocoder = CLGeocoder()
    
    func geocode(_ entry: CalendarEntry) throws -> Observable<GeoCoordinate> {
        if (entry.location.geoLocation != nil) { return Observable.just(entry.location.geoLocation!) }
        
        return geocoder.rx.geocodeAddressString(entry.address)
            .map { $0.0 }
            .errorOnNil(GeocodeError.noMatch)
            .errorOnEmpty(GeocodeError.noMatch)
            .map { $0.first! }
            .map { $0.location! }
            .map(GeoCoordinate.init)
            .do(onNext: { location in
                let realm = try! Realm()
                try! realm.write { entry.location.geoLocation = location }
            })
    }
}
