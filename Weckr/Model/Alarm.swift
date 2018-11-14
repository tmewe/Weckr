//
//  Alarm.swift
//  Weckr
//
//  Created by admin on 09.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import EventKit
import RealmSwift

class Alarm: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var date: Date!
    @objc dynamic var selectedEvent: CalendarEntry!
    @objc dynamic var route: Route!
    @objc dynamic var weather: Weather!
    @objc dynamic var location: Location!
    let otherEvents = List<CalendarEntry>()
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(date: Date,
                     selectedEvent: CalendarEntry,
                     route: Route,
                     weather: Weather,
                     location: Location) {
        self.init()
        self.date = date
        self.selectedEvent = selectedEvent
        self.route = route
        self.weather = weather
        self.location = location
    }
}
