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
                             serviceFactory: ServiceFactoryProtocol,
                             disposeBag: DisposeBag)
    func updateSelectedEvent(_ event: CalendarEntry,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol,
                             disposeBag: DisposeBag)
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
                             serviceFactory: ServiceFactoryProtocol,
                             disposeBag: DisposeBag) {
        
        updateRoute(for: alarm,
                    mode: mode,
                    start: alarm.route.legs.first!.start.position,
                    event: alarm.selectedEvent,
                    serviceFactory: serviceFactory,
                    disposeBag: disposeBag)
    }
    
    func updateSelectedEvent(_ event: CalendarEntry,
                             for alarm: Alarm,
                             serviceFactory: ServiceFactoryProtocol,
                             disposeBag: DisposeBag) {
        
        updateRoute(for: alarm,
                    mode: alarm.route.transportMode,
                    start: alarm.route.legs.first!.start.position,
                    event: event,
                    serviceFactory: serviceFactory,
                    disposeBag: disposeBag)
    }
    
    private func updateRoute(for alarm: Alarm,
                             mode: TransportMode,
                             start: GeoCoordinate,
                             event: CalendarEntry,
                             serviceFactory: ServiceFactoryProtocol,
                             disposeBag: DisposeBag) {
        let routingService = serviceFactory.createRouting()
        routingService.route(
            with: mode,
            start: start,
            end: event.location,
            arrival: event.startDate)
            .subscribe(onNext: { route in
                let realm = try! Realm()
                try! realm.write {
                    alarm.route.rawTransportMode = mode.rawValue
                    alarm.selectedEvent = event
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
}
