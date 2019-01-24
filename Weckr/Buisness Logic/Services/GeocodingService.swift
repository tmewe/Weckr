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
    func geocode(_ entry: CalendarEntry) -> Observable<CalendarEntry>
}

class GeocodingService: GeocodingServiceType {
    
    lazy var geocoder = CLGeocoder()
    
    func geocode(_ entry: CalendarEntry) -> Observable<CalendarEntry> {
        if (entry.location != nil) { return Observable.just(entry) }
    return self.geocodeAddressString(address: entry.adress)
            .map(self.processResponse)
            .flatMap {$0}
            .map {
                entry.location = $0
                return entry
            }.debug()
    }
    
    /// Get an array of CLPlacemark
    private func geocodeAddressString(address: String) -> Observable<[CLPlacemark]> {
        let sub = PublishSubject<[CLPlacemark]>()
        geocoder.geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if (error == nil) { sub.onNext(placemarks!) }
            else { sub.onError(error!) }
        })
        return sub
    }
    
    /// Convert an array of CLPlacemark to a Geocoding Object
    private func processResponse(_ placemarks: [CLPlacemark]?) -> Observable<GeoCoordinate> {
        var location: CLLocation?
        if let placemarks = placemarks, placemarks.count > 0 {
            location = placemarks.first?.location
        }
        
        if let location = location {
            let coord = GeoCoordinate.init(lat: location.coordinate.latitude, long: location.coordinate.longitude)
            return Observable.just(coord)
        } else {
            return Observable.error(GeocodeError.noMatch)
        }
        
    }
    
}
