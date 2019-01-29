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
    func updateMorningRoutine(_ time: TimeInterval,
                              for alarm: Alarm,
                              serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateTransportMode(_ mode: TransportMode,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateLocation(_ location: GeoCoordinate,
                for alarm: Alarm,
                serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateSelectedEvent(_ event: CalendarEntry,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateWeather(at location: GeoCoordinate, alarm: Alarm, serviceFactory: ServiceFactoryProtocol)
        -> Observable<Void>
    
    func updateEvents(for alarm: Alarm,
                      serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func calculateDate(for alarm: Alarm) -> Observable<Alarm>
}

struct AlarmUpdateService: AlarmUpdateServiceType {
    
    func updateMorningRoutine(_ time: TimeInterval,
                              for alarm: Alarm,
                              serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        let realmService = serviceFactory.createRealm()
        return realmService.update(morningRoutine: time, for: alarm)
            .flatMapLatest(calculateDate)
            .map { _ in Void() }
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
        
        let smartAdjustDue = isSmartAdjustDue(
            selected: mode,
            adjust: UserDefaults.standard.bool(forKey: SettingsKeys.adjustForWeather),
            forecast: alarm.weather,
            forTime: alarm.selectedEvent.startDate)
        
        let adjustedVehicle = smartAdjust(adjustDue: smartAdjustDue, selected: mode)
        
        do {
            return try geocodingService
                .geocode(event, realmService: serviceFactory.createRealm())
                .flatMapLatest { routingService.route(with:adjustedVehicle, start: start, end: $0, arrival: event.startDate, smartAdjusted: smartAdjustDue) }
                .withLatestFrom(Observable.just(alarm)) { ($0, $1) }
                .flatMapLatest(realmService.update)
                .flatMapLatest(calculateDate)
                .flatMapLatest(schedulerService.setAlarmUpdateNotification)
        } catch { return .empty() }
        
    }
    
    @discardableResult
    func calculateDate(for alarm: Alarm) -> Observable<Alarm> {
        guard let eventStartDate = alarm.selectedEvent.startDate else {
            return Observable.just(alarm)
        }
        var alarmDate = eventStartDate
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
                .debug("events", trimOutput: false)
                .withLatestFrom(Observable.just(alarm)) { ($0, $1) }
                .flatMapLatest(realmService.update)
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
    
    func updateWeather(at location: GeoCoordinate, alarm: Alarm, serviceFactory: ServiceFactoryProtocol)
        -> Observable<Void>{
        let weatherService = serviceFactory.createWeather()
        let realmService = serviceFactory.createRealm()
        
        let forecast = weatherService.forecast(for: location)
        
        let selectedTransport = TransportMode(mode: UserDefaults.standard.integer(forKey: SettingsKeys.transportMode))
        
        let result = Observable.combineLatest(forecast, Observable.just(alarm))
            .flatMap{realmService.update(forecast: $0.0, for: $0.1)}
            //Update Route when forecast is complete
            .flatMap{ self.updateRoute(for: $0, mode: selectedTransport, event: $0.selectedEvent, serviceFactory: serviceFactory)}
        
        return result
    }
    
    
    func smartAdjust(adjustDue: Bool, selected: TransportMode)
        -> TransportMode {
            return adjustDue
                ? .transit
                : selected
    }
    
    func isSmartAdjustDue(selected: TransportMode, adjust: Bool, forecast: WeatherForecast, forTime: Date) -> Bool {
        if (!adjust || selected != .pedestrian) { return false }
        for (index, weather) in forecast.weathers.enumerated() {
            guard (index + 1 < forecast.weathers.count) else { return false }
            let date = Date(timeIntervalSince1970: TimeInterval(weather.date))
            let nextDate = Date(timeIntervalSince1970: TimeInterval(forecast.weathers[index+1].date))
            
            if (forTime.isInRange(date: date, and: nextDate) && weather.rainAmount >= 0.5) {
                return true
            }
        }
        return false
    }
}
