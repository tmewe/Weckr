//
//  AlarmService.swift
//  Weckr
//
//  Created by Tim Mewe on 28.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import SwiftDate
import CoreLocation

enum AlarmCreationResult<T> {
    case Success(T)
    case Failure(AppError)
}

struct RealmService: RealmServiceType {
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            log.info("Realm is located at: " + realm.configuration.fileURL!.absoluteString)
            return try action(realm)
        } catch let err {
            log.error("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    @discardableResult
    func save(alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("creating") { realm -> Observable<Alarm> in
            try realm.write {
                alarm.id = (realm.objects(Alarm.self).max(ofProperty: "id") ?? 0) + 1
                realm.add(alarm, update: true)
                log.info("Created alarm at \(alarm.date!)")
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.creationFailed)
    }
    
    @discardableResult
    func update(alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("updating alarm") { realm -> Observable<Alarm> in
            try realm.write {
                realm.add(alarm, update: true)
                log.info("Updated alarm at \(alarm.date!)")
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    @discardableResult
    func update(location: GeoCoordinate, for entry: CalendarEntry) -> Observable<CalendarEntry> {
        let result = withRealm("updating location on entry") { realm -> Observable<CalendarEntry> in
            try realm.write {
                entry.location.geoLocation = location
            }
            return .just(entry)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    @discardableResult
    func update(location: GeoCoordinate, for alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("updating location on alarm") { realm -> Observable<Alarm> in
            try realm.write {
                alarm.location = location
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    @discardableResult
    func update(forecast: WeatherForecast, for alarm: Alarm) -> Observable<Alarm>
    {
        let result = withRealm("updating forecast on alarm") { realm -> Observable<Alarm> in
            try realm.write {
                alarm.weather = forecast
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    func update(selectedEvent: CalendarEntry, for alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("updating selected event on alarm") { realm -> Observable<Alarm> in
            try realm.write {
                alarm.selectedEvent = selectedEvent
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    @discardableResult
    func update(morningRoutine time: TimeInterval, for alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("updating selected event on alarm") { realm -> Observable<Alarm> in
            try realm.write {
                alarm.morningRoutine = time
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    @discardableResult
    func update(_ route: Route, for alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("updating selected event on alarm") { realm -> Observable<Alarm> in
            try realm.write {
                realm.add(route, update: true)
                alarm.route = route
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    @discardableResult
    func update(_ events: [CalendarEntry], for alarm: Alarm) -> Observable<Alarm> {
        guard !events.isEmpty else { return .error(AlarmServiceError.updateFailed) }
        
        let result = withRealm("updating selected event on alarm") { realm -> Observable<Alarm> in
            try realm.write {
                realm.add(events, update: true)
                alarm.otherEvents.removeAll()
                alarm.otherEvents.append(objectsIn: events)
                alarm.selectedEvent = events.first!
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.updateFailed)
    }
    
    @discardableResult
    func delete(alarm: Alarm, alarmScheduler: AlarmSchedulerServiceType) -> Observable<Void> {
        let result = withRealm("deleting") { realm -> Observable<Void> in
            try realm.write {
                log.info("Deleting alarm at \(alarm.date!)")
                realm.delete(alarm)
            }
            let alarms = realm.objects(Alarm.self)
            if alarms.isEmpty { return alarmScheduler.setNoAlarmNotification() }
            return .empty()
        }
        return result ?? .error(AlarmServiceError.deletionFailed(alarm))
    }
    
    @discardableResult
    func deletePastAlarms() -> Observable<Void> {
        let result = withRealm("deleting old alarms") { realm -> Observable<Void> in
            let alarms = realm.objects(Alarm.self)
            let start = (Date() + 1.days).dateAtStartOf(.day)
            let filtered = alarms.filter { $0.date < start }
            
            try realm.write {
                realm.delete(filtered)
            }
            return .empty()
        }
        return result ?? .error(AlarmServiceError.creationFailed)
    }
    
    @discardableResult
    func currentAlarmObservable() -> Observable<Alarm?> {
        let result = withRealm("getting alarms") { realm -> Observable<Alarm?> in
            let alarms = realm.objects(Alarm.self)
            return Observable.array(from: alarms)
                .map { alarms in
                    let start = Date()
                    return alarms
                        .sorted { $0.date < $1.date }
                        .first(where: { $0.date > start })
                }
        }
        return result ?? .empty()
    }
    
    @discardableResult
    func currentAlarm() -> Alarm? {
        let result = withRealm("getting alarms") { realm -> Alarm? in
            let alarms = realm.objects(Alarm.self)
            let start = Date()
            return alarms
                .sorted { $0.date < $1.date }
                .first(where: { $0.date > start })
        }
        return result!
    }
        
    //Returns nil if geocoordinate exists
    func checkExisting(location: GeoCoordinate) -> Observable<LocationCheckResult> {
        let result = withRealm("getting locations") { realm -> Observable<LocationCheckResult> in
            let key = location.compoundKey
            let fetched = realm.object(ofType: GeoCoordinate.self, forPrimaryKey: key)
            guard fetched != nil else { return .just((false, location)) }
            return .just((true, fetched!))
        }
        return result!
    }
    
    @discardableResult
    func createFirstAlarm(startLocation: GeoCoordinate,
                          serviceFactory: ServiceFactoryProtocol) -> Observable<AlarmCreationResult<Alarm>> {
        let date = Date() + 1.weeks
        return createAlarmPrior(to: date, startLocation: startLocation, serviceFactory: serviceFactory)
    }
    
    @discardableResult
    func createAlarmPrior(to date: Date,
                          startLocation: GeoCoordinate,
                          serviceFactory: ServiceFactoryProtocol) -> Observable<AlarmCreationResult<Alarm>> {
        
        let defaults = UserDefaults.standard
        let vehicle = defaults.integer(forKey: SettingsKeys.transportMode)
        let adjustForWeatherWanted = defaults.bool(forKey: SettingsKeys.adjustForWeather)
    
        let morningRoutineTime = defaults.double(forKey: SettingsKeys.morningRoutineTime)
        
        let calendarService = serviceFactory.createCalendar()
        let weatherService = serviceFactory.createWeather()
        let routingService = serviceFactory.createRouting()
        let geocodingService = serviceFactory.createGeocoder()
        let alarmUpdateService = serviceFactory.createAlarmUpdate()
        
        let selectedVehicleObservable = Observable.just(vehicle).map { TransportMode(mode: $0) }
        let adjustWantedObservable = Observable.just(adjustForWeatherWanted)
        
        let startLocationObservable = Observable.just(startLocation)
        let events: Observable<[CalendarEntry]>!
        
        do { events = try calendarService.fetchEventsFromNow(to: date, calendars: nil) }
        catch let error as AppError { return .just(AlarmCreationResult.Failure(error)) }
        catch { return .just(AlarmCreationResult.Failure(CalendarError.undefined)) }
        
        let weatherForecast = startLocationObservable
            .take(1)
            .flatMapLatest(weatherService.forecast)
        
        let firstEvent = events
            .map { $0.first }
            .filterNil()
            .share(replay: 1, scope: .forever)
        
        let morningRoutineObservable = Observable.just(morningRoutineTime)
        
        let arrival = firstEvent.map { $0.startDate }.filterNil()
        
        let endLocation = firstEvent
            .flatMap{ try geocodingService.geocode($0, realmService: self) }
        
        let smartAdjustDue = Observable.combineLatest(selectedVehicleObservable,
                                                      adjustWantedObservable,
                                                      weatherForecast,
                                                      firstEvent.map {$0.startDate})
            .map(alarmUpdateService.isSmartAdjustDue)
        
        let adjustedVehicle = Observable.combineLatest(smartAdjustDue, selectedVehicleObservable)
            .map(alarmUpdateService.smartAdjust)
        
        
        
        
        let route = Observable
            .zip(adjustedVehicle, startLocationObservable, endLocation, arrival, smartAdjustDue)
            .take(1)
            .flatMapLatest(routingService.route)
            .share(replay: 1, scope: .forever)
        
        let alarm = Observable.zip(route, weatherForecast) { ($0, $1) }
            .withLatestFrom(startLocationObservable) {  ($0.0, $0.1, $1) }
            .withLatestFrom(morningRoutineObservable) { ($0.0, $0.1, $0.2, $1) }
            .withLatestFrom(firstEvent) {               ($0.0, $0.1, $0.2, $0.3, $1) }
            .withLatestFrom(events) {                   ($0.0, $0.1, $0.2, $0.3, $0.4, $1) }
            .take(1)
            .map(Alarm.init)
            .flatMapLatest(alarmUpdateService.calculateDate)
            .flatMapLatest (save)
            .map { AlarmCreationResult.Success($0) }
            .observeOn(MainScheduler.instance)
            .catchError { error in
                .just(AlarmCreationResult.Failure(GeocodeError.noMatch))
            }
        
        return alarm
    }
}
