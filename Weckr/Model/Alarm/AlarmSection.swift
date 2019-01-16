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
        return "AlarmSection"
    }
    
    init(original: AlarmSection, items: [Item]) {
        self = original
        self.items = items
    }
}

enum SectionItem {
    case alarm(identity: String, date: Date)
    case morningRoutine(identity: String, time: TimeInterval)
    
    case routeOverview(identity: String, route: Route, leaveDate: Date)
    case routeCar(identity: String, route: Route)
    case routeTransit(identity: String, date: Date, getOn: Maneuver, getOff: Maneuver, transitLines: [TransitLine])
    case routePedestrian(identity: String, maneuver: Maneuver)
    
    case event(identity: String, title: String, selectedEvent: CalendarEntry)
}

extension SectionItem: IdentifiableType, Equatable {
    typealias Identity = String
    
    var identity: String {
        switch self {
        case let .alarm(identity, _),
             let .morningRoutine(identity, _),
             let .routeOverview(identity, _, _),
             let .routeCar(identity, _),
             let .routeTransit(identity, _, _, _, _),
             let .routePedestrian(identity, _),
             let .event(identity, _, _):
            return identity

        }
    }
}
