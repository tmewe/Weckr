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
    @objc dynamic var event: EKEvent!
}
