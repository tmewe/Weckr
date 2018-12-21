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

extension AlarmSection: AnimatableSectionModelType {
    typealias Item = SectionItem
    typealias Identity = String
    
    var identity: String {
        return ""
    }
    
    init(original: AlarmSection, items: [Item]) {
        self = original
        self.items = items
    }
}

enum SectionItem {
    case alarmItem(identity: String, date: Date)
    case morningRoutineItem(identity: String, time: TimeInterval)
    case routeItem(identity: String, route: Route)
    case eventItem(identity: String, title: String, selectedEvent: CalendarEntry)
}

extension SectionItem: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        return ""
    }
}
