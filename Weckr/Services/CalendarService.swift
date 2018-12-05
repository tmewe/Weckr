//
//  CalendarService.swift
//  Weckr
//
//  Created by Tim Mewe on 28.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import EventKit
import RxSwift

struct CalendarService: CalendarServiceType {
    
    func fetchEvents(at date: Date, calendars: [EKCalendar]?) -> Observable<[CalendarEntry]> {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            let store = EKEventStore()
            let predicate = store.predicateForEvents(withStart: Date(), end: date, calendars: calendars)
            
            let events = store.events(matching: predicate)
                .sorted { $0.startDate < $1.startDate }
                //FIXME: Handle events without geolocation, don't just filter them out
                .filter { $0.structuredLocation?.geoLocation != nil }
                .map { ($0.title!, $0.startDate!, $0.endDate!, GeoCoordinate(location: $0.structuredLocation!.geoLocation!)) }
                .map(CalendarEntry.init)
            return Observable.of(events)
        default:
            return Observable.error(AccessError.calendar)
        }
    }
    
    
}
