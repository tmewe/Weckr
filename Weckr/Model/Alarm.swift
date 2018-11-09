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
    let otherEvents = List<CalendarEntry>()
    @objc dynamic var route: Route!
}
