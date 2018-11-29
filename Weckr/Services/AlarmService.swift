//
//  AlarmService.swift
//  Weckr
//
//  Created by Tim Mewe on 28.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm

struct AlarmService: AlarmServiceType {
    
    fileprivate func withRealm<T>(_ operation: String, action: (Realm) throws -> T) -> T? {
        do {
            let realm = try Realm()
            print("Realm is located at:", realm.configuration.fileURL!)
            return try action(realm)
        } catch let err {
            print("Failed \(operation) realm with error: \(err)")
            return nil
        }
    }

    @discardableResult
    func save(alarm: Alarm) -> Observable<Alarm> {
        let result = withRealm("creating") { realm -> Observable<Alarm> in
            try realm.write {
                alarm.id = (realm.objects(Alarm.self).max(ofProperty: "id") ?? 0) + 1
                realm.add(alarm, update: true)
            }
            return .just(alarm)
        }
        return result ?? .error(AlarmServiceError.creationFailed)
    }
}
