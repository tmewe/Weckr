//
//  AuthorizationStatusService.swift
//  Weckr
//
//  Created by Tim Mewe on 09.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import UserNotifications
import EventKit
import RxSwift

//Only for notification and event store
protocol AuthorizationStatusServiceType {
    func notificationAuthorization() -> Observable<Error?>
    func eventStoreAuthorization() -> Observable<Error?>
}

class AuthorizationStatusService: AuthorizationStatusServiceType {
    
    func notificationAuthorization() -> Observable<Error?> {
        let center = UNUserNotificationCenter.current()
        return center.rx.requestAuthorization(options: [.badge, .alert, .sound])
            .map { $0.0 }
            .map { $0 ? nil : AccessError.notification }
    }
    
    func eventStoreAuthorization() -> Observable<Error?> {
        let status = EKEventStore.authorizationStatus(for: .event)
        guard status == .authorized else { return Observable.just(AccessError.calendar) }
        return Observable.just(nil)
    }
}
