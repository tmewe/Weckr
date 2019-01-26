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
import CoreLocation

protocol AlarmUpdateServiceType {
    func updateMorningRoutine(_ time: TimeInterval, for alarm: Alarm)
    func updateTransportMode(_ mode: TransportMode,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateLocation(_ location: GeoCoordinate,
                for alarm: Alarm,
                serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateSelectedEvent(_ event: CalendarEntry,
                for alarm: Alarm,
                serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateEvents(for alarm: Alarm,
                      serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func calculateDate(for alarm: Alarm) -> Observable<Alarm>
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
                    event: alarm.selectedEvent,
                    serviceFactory: serviceFactory)
    }
    
    func updateSelectedEvent(_ event: CalendarEntry,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        
        return updateRoute(for: alarm,
                    mode: alarm.route.transportMode,
                    event: event,
                    serviceFactory: serviceFactory)
    }
    
    private func updateRoute(for alarm: Alarm,
                             mode: TransportMode,
                             event: CalendarEntry,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        
        log.info("Update route for alarm at \(alarm.date!) and \(event.title!)")
        
        let routingService = serviceFactory.createRouting()
        let geocodingService = serviceFactory.createGeocoder()
        let realmService = serviceFactory.createRealm()
        let schedulerService = serviceFactory.createAlarmScheduler()
        
        guard let start = alarm.location else { return .empty() }
        
        return try! geocodingService
            .geocode(event, realmService: serviceFactory.createRealm())
            .debug()
            .flatMapLatest { routingService.route(with: mode, start: start, end: $0, arrival: event.startDate) }
            .map { route in
                let update = Alarm(route: route,
                                   weather: alarm.weather,
                                   location: start,
                                   morningRoutine: alarm.morningRoutine,
                                   selectedEvent: event,
                                   otherEvents: alarm.otherEvents.toArray())
                update.id = alarm.id
                return update
            }
            .withLatestFrom(Observable.just(realmService)) { ($0, $1) }
            .flatMapLatest(update)
            .flatMapLatest(schedulerService.setAlarmUpdateNotification)
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
                .withLatestFrom(Observable.just(realmService)) { ($0, $1) }
                .flatMapLatest(update)
                .withLatestFrom(Observable.just(transportMode)) { ($0, $1) }
                .withLatestFrom(Observable.just(alarm.selectedEvent)) { ($0.0, $0.1, $1) }
                .withLatestFrom(Observable.just(serviceFactory)) { ($0.0, $0.1, $0.2, $1) }
                .flatMapLatest(updateRoute)
        }
        catch CalendarError.noEvents {
            return realmService.delete(alarm: alarm,
                                       alarmScheduler: serviceFactory.createAlarmScheduler())
        }
        catch { return .empty() }
    }
    
    func updateLocation(_ location: GeoCoordinate,
                for alarm: Alarm,
                serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        
        let realmService = serviceFactory.createRealm()
        
        guard !alarm.isInvalidated else { return .empty() }
        
        let first = CLLocation(coordinate: alarm.location)
        let second = CLLocation(coordinate: location)
        let distance = first.distance(from: second) //meters
        
        guard distance > 200 else { return .empty() }
        return realmService
            .update(location: location, for: alarm)
            .flatMap { self.updateRoute(for: $0,
                                        mode: alarm.route.transportMode,
                                        event: alarm.selectedEvent,
                                        serviceFactory: serviceFactory) }
    }
    
    @discardableResult
    private func update(alarm: Alarm, service: RealmServiceType) -> Observable<Alarm> {
        return calculateDate(for: alarm)
            .flatMapLatest(service.update)
    }
}
