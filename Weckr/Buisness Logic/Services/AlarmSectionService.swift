//
//  AlarmSectionService.swift
//  Weckr
//
//  Created by Tim Mewe on 25.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import SwiftDate

protocol AlarmSectionServiceType {
    func alarmItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]>
    func morningRoutineItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]>
    func routeOverviewItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]>
    func allRouteItems(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]>
    func eventItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]>
}

struct AlarmSectionService: AlarmSectionServiceType {
    
    func alarmItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]> {
        return alarm.map { alarm -> [AlarmSectionItem] in
            guard let alarm = alarm else { return [] }
            return [AlarmSectionItem.alarm(identity: "alarm", date: alarm.date)] }
    }
    
    func morningRoutineItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]> {
        return alarm.map { alarm -> [AlarmSectionItem] in
            guard let alarm = alarm else { return [] }
            return [AlarmSectionItem.morningRoutine(identity: "morningroutine",
                                                    time: alarm.morningRoutine)] }
    }
    
    func routeOverviewItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]> {
        return alarm.map { alarm -> [AlarmSectionItem] in
            guard let alarm = alarm else { return [] }
            let leaveDate = alarm.selectedEvent.startDate - alarm.route.summary.trafficTime.seconds
            return [AlarmSectionItem.routeOverview(identity: "3", route: alarm.route, leaveDate: leaveDate)]
        }
    }
    
    func allRouteItems(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]> {
        return alarm.map { alarm -> [AlarmSectionItem] in
            
            guard let alarm = alarm else { return [] }
            
            let route = alarm.route!
            let leaveDate = alarm.selectedEvent.startDate - alarm.route.summary.trafficTime.seconds
            var items = [AlarmSectionItem.routeOverview(identity: "3",
                                                        route: route,
                                                        leaveDate: leaveDate)]
            
            switch route.transportMode {
            case .car:
                items.append(AlarmSectionItem.routeCar(identity: "4", route: route))
                
            case .pedestrian, .transit:
                
                var maneuverDate = leaveDate //For transit departure and arrival
                var skipNext = false
                let maneuvers = route.legs.first!.maneuvers.dropLast()
                for (index, maneuver) in maneuvers.enumerated() {
                    
                    guard !skipNext else {
                        skipNext = false
                        continue
                    }
                    
                    switch maneuver.transportType {
                        
                    case .privateTransport:
                        items.append(AlarmSectionItem.routePedestrian(
                            identity: maneuver.id,
                            maneuver: maneuver))
                        
                    case .publicTransport:
                        skipNext = true
                        let getOn = maneuver
                        let getOff = maneuvers[index + 1]
                        items.append(AlarmSectionItem.routeTransit(identity: maneuver.id,
                                                                   date: maneuverDate,
                                                                   getOn: getOn,
                                                                   getOff: getOff,
                                                                   transitLines: route.transitLines.toArray()))
                    }
                    
                    maneuverDate = maneuverDate + maneuver.travelTime.seconds
                }
            }
            return items
        }
    }
    
    func eventItem(for alarm: Observable<Alarm?>) -> Observable<[AlarmSectionItem]> {
        return alarm.map { alarm -> [AlarmSectionItem] in
            guard let alarm = alarm else { return [] }
            return [AlarmSectionItem.event(identity: "event",
                                           title: Strings.Cells.FirstEvent.title,
                                           selectedEvent: alarm.selectedEvent)] }
    }
}
