//
//  CalendarEntry.swift
//  Weckr
//
//  Created by admin on 09.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift
import EventKit

class CalendarEntry: Object {
    @objc dynamic var title: String!
    @objc dynamic var startDate: Date!
    @objc dynamic var endDate: Date!
    @objc dynamic var adress: String!
    @objc dynamic var location: CalendarLocation!
    @objc dynamic var compoundKey: String!
    
    override public class func primaryKey() -> String? {
        return "compoundKey"
    }
    
    convenience init(title: String, startDate: Date, endDate: Date, adress: String, location: CalendarLocation) {
        self.init()
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.adress = adress
        self.location = location
        self.compoundKey = startDate.toFormat("dd:HH:mm") + endDate.toFormat("dd:HH:mm")
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let entry = object as? CalendarEntry else { return false }
        return title == entry.title && startDate == entry.startDate && endDate == entry.endDate
    }
}
