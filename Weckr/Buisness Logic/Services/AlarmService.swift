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

struct AlarmService: AlarmServiceType {
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            print("Realm is located at:", realm.configuration.fileURL!)
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }
    
    @discardableResult
    func save(alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("creating") { realm -> Observable<Alarm> in
            try realm.write {
                alarm.id = (realm.objects(Alarm.self).max(ofProperty: "id") ?? 0) + 1
                realm.add(alarm, update: true)
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.creationFailed)
    }
    
    @discardableResult
    func currentAlarmObservable() -> Observable<Alarm> {
        let result = withRealm("getting alarms") { realm -> Observable<Alarm> in
            let alarms = realm.objects(Alarm.self)
            return Observable.array(from: alarms)
                .map { alarms in
                    alarms.sorted { $0.date < $1.date }.first(where: { $0.date > Date() }) }
                .filterNil()
        }
        return result ?? .empty()
    }
    
    @discardableResult
    func currentAlarm() -> Alarm? {
        let result = withRealm("getting alarms") { realm -> Alarm? in
            let alarms = realm.objects(Alarm.self)
            return alarms
                .sorted { $0.date < $1.date }
                .first(where: { $0.date > Date() })
        }
        return result!
    }
    
    func update(alarm: Alarm, with morningRoutineTime: TimeInterval) {
        let realm = try! Realm()
        try! realm.write {
            alarm.morningRoutine = morningRoutineTime
        }
        calculateDate(for: alarm)
    }
    
    func update(alarm: Alarm,
                with selectedEvent: CalendarEntry,
                serviceFactory: ServiceFactoryProtocol,
                disposeBag: DisposeBag) {
        
        let routingService = serviceFactory.createRouting()
        routingService.route(
            with: .transit,
            start: alarm.route.legs.first!.start.position,
            end: selectedEvent.location,
            arrival: selectedEvent.startDate)
            .subscribe(onNext: { route in
                let realm = try! Realm()
                try! realm.write {
                    alarm.selectedEvent = selectedEvent
                    alarm.route = route
                }
                self.calculateDate(for: alarm)
            })
            .disposed(by: disposeBag)
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
    
    func createAlarm(vehicle: Vehicle,
                     morningRoutineTime: TimeInterval,
                     startLocation: GeoCoordinate,
                     serviceFactory: ServiceFactoryProtocol) -> Observable<Alarm> {
        
        let calendarService = serviceFactory.createCalendar()
        let weatherService = serviceFactory.createWeather()
        let routingService = serviceFactory.createRouting()
        
        let vehicleObservable = Observable.just(vehicle)
        let startLocationObservable = Observable.just(startLocation)
        let futureDate = Date() + 1.days
        let events = calendarService.fetchEvents(at: futureDate, calendars: nil)
        let firstEvent = events
            .map { $0.first }
            .filterNil()
            .share(replay: 1, scope: .forever)
        
        let morningRoutineObservable = Observable.just(morningRoutineTime)
        
        let arrival = firstEvent.map { $0.startDate }.filterNil()
        
        let endLocation = firstEvent
            .map { $0.location }
            .filterNil()
        
        let route = Observable
            .combineLatest(vehicleObservable, startLocationObservable, endLocation, arrival)
            .take(1)
            .flatMapLatest(routingService.route)
            .share(replay: 1, scope: .forever)
        
        let weatherForecast = startLocationObservable
            .map(weatherService.forecast)
            .flatMapLatest { $0 }
        
        let alarm = Observable.zip(route, weatherForecast) { ($0, $1) }
            .withLatestFrom(startLocationObservable) {  ($0.0, $0.1, $1) }
            .withLatestFrom(morningRoutineObservable) { ($0.0, $0.1, $0.2, $1) }
            .withLatestFrom(firstEvent) {               ($0.0, $0.1, $0.2, $0.3, $1) }
            .withLatestFrom(events) {                   ($0.0, $0.1, $0.2, $0.3, $0.4, $1) }
            .take(1)
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map(Alarm.init)
            .flatMapLatest (save)
            .flatMapLatest(calculateDate)
            .observeOn(MainScheduler.instance)
        
        return alarm
    }
    
}
