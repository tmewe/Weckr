//
//  UNUserNotificationCenter+Extensions.swift
//  Weckr
//
//  Created by Tim Mewe on 22.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift
import RxCocoa

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

extension Reactive where Base: UNUserNotificationCenter {
    @discardableResult
    func requestAuthorization(options: UNAuthorizationOptions) -> Observable<(Bool, Error?)> {
        return Observable.create { observer in
            self.base.requestAuthorization(options: options, completionHandler: { (granted, error) in
                guard error == nil else {
                    observer.onError(AccessError.notification)
                    return
                }
                observer.onNext((granted, error))
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
    
    public var delegate: DelegateProxy<UNUserNotificationCenter,UNUserNotificationCenterDelegate> {
        return RxUNUserNotificationCenterDelegateProxy.proxy(for: base)
    }
    
    public var willPresent: ControlEvent<UNNotification> {
        let source = delegate
            .methodInvoked(#selector(UNUserNotificationCenterDelegate
                .userNotificationCenter(_:willPresent:withCompletionHandler:)))
            .map { a in
                return try castOrThrow(UNNotification.self, a[1])
            }
        return ControlEvent(events: source)
    }
}
