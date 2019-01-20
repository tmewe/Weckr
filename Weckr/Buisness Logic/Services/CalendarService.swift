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
import SwiftDate

protocol CalendarServiceType {
    func fetchEvents(at date: Date, calendars: [EKCalendar]?) throws -> Observable<[CalendarEntry]>
    func fetchEventsForNextWeek(calendars: [EKCalendar]?) throws -> Observable<[CalendarEntry]>
    func fetchEventsFromNow(to date: Date, calendars: [EKCalendar]?) throws -> Observable<[CalendarEntry]>
}

struct CalendarService: CalendarServiceType {
    
    func fetchEvents(at date: Date, calendars: [EKCalendar]?) throws -> Observable<[CalendarEntry]> {
        let dayStart = date.dateAtStartOf(.day)
        let dayEnd = date.dateAtEndOf(.day)
        return try fetchEvents(from: dayStart, to: dayEnd, calendars: calendars)
    }
    
    func fetchEventsForNextWeek(calendars: [EKCalendar]?) throws -> Observable<[CalendarEntry]> {
        let start = Date() + 1.days
        let end = Date() + 8.days
        let weekStart = start.dateAtStartOf(.day)
        let weekEnd = end.dateAtEndOf(.day)
        return try fetchEvents(from: weekStart, to: weekEnd, calendars: calendars)
    }
    
    func fetchEventsFromNow(to date: Date, calendars: [EKCalendar]?) throws -> Observable<[CalendarEntry]> {
        let start = (Date() + 1.days).dateAtStartOf(.day)
        let end = (date - 1.days).dateAtEndOf(.day)
        return try fetchEvents(from: start, to: end, calendars: calendars)
    }
    
    private func fetchEvents(from startDate: Date, to endDate: Date, calendars: [EKCalendar]?) throws -> Observable<[CalendarEntry]> {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:
            let store = EKEventStore()
            var date = startDate //For iteration
            
            while date < endDate {
                let morning = date.dateAtStartOf(.day)
                let evening = date.dateAtEndOf(.day)
                
                let predicate = store.predicateForEvents(withStart: morning, end: evening, calendars: calendars)
                
                let events = store.events(matching: predicate)
                    .sorted { $0.startDate < $1.startDate }
                    //FIXME: Handle events without geolocation, don't just filter them out
                    .filter { $0.structuredLocation?.geoLocation != nil }
                    .filter { !$0.isAllDay }
                    .map { ($0.title!,
                            $0.startDate!,
                            $0.endDate!,
                            $0.location!,
                            GeoCoordinate(location: $0.structuredLocation!.geoLocation!))
                    }
                    .map(CalendarEntry.init)
                guard events.isEmpty else {
                    log.info("Found \(events.count) events at \(date)")
                    return Observable.of(events)
                }
                
                date = date + 1.days
            }
            throw CalendarError.noEvents
            
        default:
            throw AccessError.calendar
        }
    }
    
    
}
