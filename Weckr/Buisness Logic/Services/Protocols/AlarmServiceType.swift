//
//  AlarmServiceType.swift
//  Weckr
//
//  Created by Tim Mewe on 28.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import CoreLocation

protocol AlarmServiceType {
    @discardableResult
    func save(alarm: Alarm) -> Observable<Alarm>
    
    func calculateDate(for alarm: Alarm) -> Observable<Alarm>
    
//    @discardableResult
//    func delete(alarm: Alarm) -> Observable<Void>
//
//    @discardableResult
//    func allAlarms() -> Observable<Results<Alarm>>

    @discardableResult
    func currentAlarmObservable() -> Observable<Alarm>
    
    @discardableResult
    func currentAlarm() -> Alarm?
    
    func update(alarm: Alarm, with morningRoutineTime: TimeInterval)
    func update(alarm: Alarm,
                with selectedEvent: CalendarEntry,
                serviceFactory: ServiceFactoryProtocol,
                disposeBag: DisposeBag)
    
    func createAlarm(vehicle: Vehicle,
                     morningRoutineTime: TimeInterval,
                     startLocation: GeoCoordinate,
                     serviceFactory: ServiceFactoryProtocol) -> Observable<Alarm>
}
