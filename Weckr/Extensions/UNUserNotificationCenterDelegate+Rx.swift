//
//  UNUserNotificationCenterDelegate+Rx.swift
//  Weckr
//
//  Created by Tim Mewe on 13.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UserNotifications

extension UNUserNotificationCenter: HasDelegate {
    public typealias Delegate = UNUserNotificationCenterDelegate
}

extension DelegateProxyType where ParentObject: HasDelegate, Self.Delegate == ParentObject.Delegate {
    public static func currentDelegate(for object: ParentObject) -> Delegate? {
        return object.delegate
    }
    
    public static func setCurrentDelegate(_ delegate: Delegate?, to object: ParentObject) {
        object.delegate = delegate
    }
}

class RxUNUserNotificationCenterDelegateProxy: DelegateProxy<UNUserNotificationCenter,UNUserNotificationCenterDelegate>,
    DelegateProxyType,
    UNUserNotificationCenterDelegate {
    
    public weak private(set) var userNotificationCenter: UNUserNotificationCenter?
    
    public init(userNotificationCenter: ParentObject) {
        self.userNotificationCenter = userNotificationCenter
        super.init(parentObject: userNotificationCenter,
                   delegateProxy: RxUNUserNotificationCenterDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxUNUserNotificationCenterDelegateProxy(userNotificationCenter: $0) }
    }
}
