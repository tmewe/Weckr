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
    func nextAlarm() -> Observable<Alarm>
    
    func createAlarm(startLocation: GeoCoordinate, vehicle: Vehicle, morningRoutineTime: TimeInterval, calendarService: CalendarServiceType, weatherService: WeatherServiceType, routingService: RoutingServiceType) -> Observable<Alarm>
}
