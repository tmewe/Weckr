//
//  AlarmUpdateService.swift
//  Weckr
//
//  Created by Tim Mewe on 18.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm
import SwiftDate

protocol AlarmUpdateServiceType {
    func updateMorningRoutine(_ time: TimeInterval, for alarm: Alarm)
    func calculateDate(for alarm: Alarm) -> Observable<Alarm>
    func updateTransportMode(_ mode: TransportMode,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateSelectedEvent(_ event: CalendarEntry,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateEvents(for alarm: Alarm,
                      serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
//    func updateLocation(for alarm: Alarm, location: GeoCoordinate, disposeBag: DisposeBag)
}

struct AlarmUpdateService: AlarmUpdateServiceType {
    
    func updateMorningRoutine(_ time: TimeInterval, for alarm: Alarm) {
        let realm = try! Realm()
        try! realm.write {
            alarm.morningRoutine = time
        }
        calculateDate(for: alarm)
    }
    
    func updateTransportMode(_ mode: TransportMode,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        
        return updateRoute(for: alarm,
                    mode: mode,
                    start: alarm.route.legs.first!.start.position,
                    event: alarm.selectedEvent,
                    serviceFactory: serviceFactory)
    }
    
    func updateSelectedEvent(_ event: CalendarEntry,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        
        return updateRoute(for: alarm,
                    mode: alarm.route.transportMode,
                    start: alarm.route.legs.first!.start.position,
                    event: event,
                    serviceFactory: serviceFactory)
    }
    
    private func updateRoute(for alarm: Alarm,
                             mode: TransportMode,
                             start: GeoCoordinate,
                             event: CalendarEntry,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        let routingService = serviceFactory.createRouting()
        let geocodingService = serviceFactory.createGeocoder()
        
        log.info("Update route for alarm at \(alarm.date!) and \(event.title!)")
        
        return try! geocodingService
            .geocode(event, realmService: serviceFactory.createRealm())
            .debug()
            .flatMapLatest { routingService.route(with: mode, start: start, end: $0, arrival: event.startDate) }
            .map { route in
                let realmService = serviceFactory.createRealm()
                let update = Alarm(route: route,
                                   weather: alarm.weather,
                                   location: start,
                                   morningRoutine: alarm.morningRoutine,
                                   selectedEvent: event,
                                   otherEvents: alarm.otherEvents.toArray())
                update.id = alarm.id
                self.update(alarm: update, service: realmService)
            }
    }
    
    @discardableResult
    func calculateDate(for alarm: Alarm) -> Observable<Alarm> {
        guard let eventStartDate = alarm.selectedEvent.startDate else {
            return Observable.just(alarm)
        }
        let alarmDate = eventStartDate
            - Int(alarm.morningRoutine).seconds
            - Int(alarm.route.summary.travelTime).seconds
        
        let realm = try! Realm()
        try! realm.write {
            alarm.date = alarmDate
        }
        return Observable.just(alarm)
    }
    
    func updateEvents(for alarm: Alarm,
                      serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        let calendarService = serviceFactory.createCalendar()
        let realmService = serviceFactory.createRealm()
        do {
            
            let events = try calendarService
                .fetchEvents(at: alarm.date, calendars: nil)
                .filterEmpty()
                .share(replay: 1, scope: .forever)
            let transportMode = TransportMode(mode: UserDefaults.standard.integer(forKey: SettingsKeys.transportMode))
            
            return events
                .map { events in
                    let update = Alarm(route: alarm.route,
                                       weather: alarm.weather,
                                       location: alarm.location,
                                       morningRoutine: alarm.morningRoutine,
                                       selectedEvent: events.first!,
                                       otherEvents: events)
                    update.id = alarm.id
                    return update
                }
                .map { return self.update(alarm: $0, service: realmService) } 
                .flatMapLatest { alarm in
                    self.updateRoute(for: alarm,
                                    mode: transportMode,
                                    start: alarm.location,
                                    event: alarm.selectedEvent,
                                    serviceFactory: serviceFactory) }
        }
        catch CalendarError.noEvents {
            realmService.delete(alarm: alarm, alarmScheduler: serviceFactory.createAlarmScheduler())
            return .empty()
        }
        catch { return .empty() }
    }
    
    @discardableResult
    private func update(alarm: Alarm, service: RealmServiceType) -> Alarm {
        self.calculateDate(for: alarm)
        service.update(alarm: alarm)
        return alarm
    }
}
