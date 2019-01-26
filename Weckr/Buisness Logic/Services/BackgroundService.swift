//
//  BackgroundService.swift
//  Weckr
//
//  Created by Tim Mewe on 20.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift

protocol BackgroundServiceType {
    func createFirstAlarm(at location: Observable<GeoCoordinate>,
                          realmService: RealmServiceType,
                          serviceFactory: ServiceFactoryProtocol) -> Observable<AlarmCreationResult<Alarm>>
    func updateCurrent(alarm: Alarm?,
                       updateService: AlarmUpdateServiceType,
                       serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
    func updateEventsPrior(to alarm: Alarm?,
                           location: Observable<GeoCoordinate>,
                           realmService: RealmServiceType,
                           serviceFactory: ServiceFactoryProtocol) -> Observable<Void>
}

class BackgroundService: BackgroundServiceType {
    
    func createFirstAlarm(at location: Observable<GeoCoordinate>,
                          realmService: RealmServiceType,
                          serviceFactory: ServiceFactoryProtocol) -> Observable<AlarmCreationResult<Alarm>> {
        log.info("Background fetch: New first alarm start")
        return location
            .withLatestFrom(Observable.just(serviceFactory)) { ($0, $1) }
            .flatMapLatest(realmService.createFirstAlarm)
    }
    
    func updateCurrent(alarm: Alarm?,
                       updateService: AlarmUpdateServiceType,
                       serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        log.info("Background fetch: Updated current alarm start")
        return Observable.just(alarm)
            .filterNil()
            .withLatestFrom(Observable.just(serviceFactory)) { ($0, $1) }
            .flatMapLatest(updateService.updateEvents)
    }
    
    func updateEventsPrior(to alarm: Alarm?,
                           location: Observable<GeoCoordinate>,
                           realmService: RealmServiceType,
                           serviceFactory: ServiceFactoryProtocol) -> Observable<Void> {
        log.info("Background fetch: Updated prior to alarm start")
        let date = Observable.just(alarm)
            .filterNil()
            .filter { !$0.isInvalidated } //Needed if alarm gets deleted
            .map { $0.date! }
        
        return Observable.combineLatest(date, location)
            .withLatestFrom(Observable.just(serviceFactory)) { ($0.0, $0.1, $1) }
            .flatMapLatest(realmService.createAlarmPrior)
            .map { _ in Void() }
    }
}
