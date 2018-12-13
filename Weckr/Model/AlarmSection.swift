//
//  AlarmSectionModel.swift
//  Weckr
//
//  Created by Tim Mewe on 03.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxDataSources

struct AlarmSection {
    var header: String
    var items: [SectionItem]
}

extension AlarmSection: SectionModelType {
    typealias Item = SectionItem
    
    init(original: AlarmSection, items: [Item]) {
        self = original
        self.items = items
    }
}

enum SectionItem {
    case alarmItem(date: Date)
    case morningRoutineItem(time: TimeInterval)
    case routeItem(route: Route)
    case eventItem(title: String, selectedEvent: CalendarEntry)
}
