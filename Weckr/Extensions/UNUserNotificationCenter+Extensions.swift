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

extension Reactive where Base: UNUserNotificationCenter {
    @discardableResult
    func requestAuthorization(options: UNAuthorizationOptions) -> Observable<(Bool, Error?)> {
        return Observable.create { observer in
            self.base.requestAuthorization(options: options, completionHandler: { (granted, error) in
                guard error == nil else {
                    observer.onError(error!)
                    return
                }
                observer.onNext((granted, error))
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
