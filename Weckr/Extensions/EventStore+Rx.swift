//
//  EventStore+Extensions.swift
//  Weckr
//
//  Created by Tim Mewe on 18.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import EventKit

extension Reactive where Base: EKEventStore {
    @discardableResult
    func requestAccess(to entityType: EKEntityType) -> Observable<(Bool, Error?)> {
        return Observable.create { observer in
            self.base.requestAccess(to: entityType, completion: { (granted, error) in
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
