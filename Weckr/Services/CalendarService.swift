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
            let predicate = store.predicateForEvents(withStart: date, end: date, calendars: calendars)
            let events = store.events(matching: predicate)
                .sorted { $0.startDate < $1.startDate }
                .map(CalendarEntry.init)
            return Observable.of(events)
        default:
            return Observable.error(AccessError.calendar)
        }
    }
    
    
}
