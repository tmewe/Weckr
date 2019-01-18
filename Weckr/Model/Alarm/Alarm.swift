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

@objcMembers class Alarm: Object {
    dynamic var id: Int = 0
    dynamic var date: Date!
    dynamic var selectedEvent: CalendarEntry!
    dynamic var route: Route!
    dynamic var weather: WeatherForecast!
    dynamic var location: GeoCoordinate!
    dynamic var morningRoutine: TimeInterval = 0.0
    var otherEvents = List<CalendarEntry>()
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(route: Route,
                     weather: WeatherForecast,
                     location: GeoCoordinate,
                     morningRoutine: TimeInterval,
                     selectedEvent: CalendarEntry,
                     otherEvents: [CalendarEntry]) {
        self.init()
        self.selectedEvent = selectedEvent
        self.route = route
        self.weather = weather
        self.location = location
        self.morningRoutine = morningRoutine
        self.otherEvents.append(objectsIn: otherEvents)
    }
}
