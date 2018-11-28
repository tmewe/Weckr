//
//  EventsServiceType.swift
//  Weckr
//
//  Created by Tim Mewe on 28.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

protocol CalendarServiceType {
    func fetchEvents(at date: Date, calendars: [EKCalendar]?) -> Observable<[EKEvent]>
}
