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

protocol GeocodingServiceType{
    func geocode(_ entry: CalendarEntry) throws -> Observable<GeoCoordinate>
}

class GeocodingService: GeocodingServiceType {
    
    lazy var geocoder = CLGeocoder()
    
    func geocode(_ entry: CalendarEntry) throws -> Observable<GeoCoordinate> {
        if (entry.location.geoLocation != nil) { return Observable.just(entry.location.geoLocation!) }
        return try self.geocodeAddressString(address: entry.adress)
            .flatMap(self.processResponse)
    }
    
    /// Get an array of CLPlacemark
    private func geocodeAddressString(address: String) throws -> Observable<[CLPlacemark]> {
        let sub = BehaviorSubject<[CLPlacemark]>(value: [])
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if (error == nil) { sub.onNext(placemarks!) }
            else { sub.onError(error!) }
        })
        return sub.asObservable()
    }
    
    /// Convert an array of CLPlacemark to a Geocoding Object
    private func processResponse(_ placemarks: [CLPlacemark]?) throws -> Observable<GeoCoordinate> {
        var location: CLLocation?
        if let placemarks = placemarks, placemarks.count > 0 {
            location = placemarks.first?.location
        }
        
        if let location = location {
            let coord = GeoCoordinate.init(lat: location.coordinate.latitude, long: location.coordinate.longitude)
            return Observable.just(coord)
        } else {
            throw GeocodeError.noMatch
        }
        
    }
    
}
