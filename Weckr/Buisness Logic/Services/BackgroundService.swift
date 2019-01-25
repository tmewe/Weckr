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
                          serviceFactory: ServiceFactoryProtocol,
                          disposeBag: DisposeBag)
    func updateCurrent(alarm: Alarm?,
                       updateService: AlarmUpdateServiceType,
                       serviceFactory: ServiceFactoryProtocol,
                       disposeBag: DisposeBag)
    func updateEventsPrior(to alarm: Alarm?,
                           location: Observable<GeoCoordinate>,
                           realmService: RealmServiceType,
                           serviceFactory: ServiceFactoryProtocol,
                           disposeBag: DisposeBag)
}

class BackgroundService: BackgroundServiceType {
    
    
    func createFirstAlarm(at location: Observable<GeoCoordinate>,
                          realmService: RealmServiceType,
                          serviceFactory: ServiceFactoryProtocol,
                          disposeBag: DisposeBag) {
        log.info("Background fetch: New first alarm start")
        location
            .debug("background new", trimOutput: true)
            .flatMap { realmService
                .createFirstAlarm(startLocation: $0, serviceFactory: serviceFactory) }
            .subscribe(onNext: { _ in log.info("Background fetch: New first alarm end") })
            .disposed(by: disposeBag)
    }
    
    func updateCurrent(alarm: Alarm?,
                       updateService: AlarmUpdateServiceType,
                       serviceFactory: ServiceFactoryProtocol,
                       disposeBag: DisposeBag) {
        log.info("Background fetch: Updated current alarm start")
        Observable.just(alarm)
            .filterNil()
            .map { updateService.updateEvents(for: $0,
                                              serviceFactory: serviceFactory) }
            .subscribe(onNext: { _ in log.info("Background fetch: Updated current alarm finish") })
            .disposed(by: disposeBag)
    }
    
    func updateEventsPrior(to alarm: Alarm?,
                           location: Observable<GeoCoordinate>,
                           realmService: RealmServiceType,
                           serviceFactory: ServiceFactoryProtocol,
                           disposeBag: DisposeBag) {
        log.info("Background fetch: Updated prior to alarm start")
        let date = Observable.just(alarm)
            .filterNil()
            .filter { !$0.isInvalidated } //Needed if alarm gets deleted
            .map { $0.date! }
        
        Observable.combineLatest(date, location)
            .flatMap { realmService.createAlarmPrior(to: $0.0,
                                                     startLocation: $0.1,
                                                     serviceFactory: serviceFactory) }
            .subscribe(onNext: { _ in log.info("Background fetch: Updated prior to alarm end") })
            .disposed(by: disposeBag)
    }
}
