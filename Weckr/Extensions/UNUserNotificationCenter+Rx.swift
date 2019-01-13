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
    
    public typealias UNCenterNotifiation = (center: UNUserNotificationCenter, notification: UNNotification, completion: (UNNotificationPresentationOptions) -> (Void))
    
    private func unCenterNotification(_ args: [Any]) throws -> UNCenterNotifiation {
        typealias __CompletionHandler = @convention(block) (UNNotificationPresentationOptions) -> (Void)
        let center = try castOrThrow(UNUserNotificationCenter.self, args[0])
        let notification = try castOrThrow(UNNotification.self, args[1])
        
        var closureObject: AnyObject? = nil
        var mutableArgs = args
        mutableArgs.withUnsafeMutableBufferPointer { ptr in
            closureObject = ptr[2] as AnyObject
        }
        let __confirmBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
        let completion = unsafeBitCast(__confirmBlockPtr, to: __CompletionHandler.self)
        
        return (center, notification, completion)
    }
    
    public var willPresent: ControlEvent<UNCenterNotifiation> {
        let source = delegate
            .methodInvoked(#selector(UNUserNotificationCenterDelegate
                .userNotificationCenter(_:willPresent:withCompletionHandler:)))
            .map(unCenterNotification)
        return ControlEvent(events: source)
    }
}
