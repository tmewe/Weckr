//
//  CLGeocoder+Rx.swift
//  Weckr
//
//  Created by Tim Mewe on 23.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import CoreLocation

extension Reactive where Base: CLGeocoder {
    func geocodeAddressString(_ addressString: String) -> Observable<([CLPlacemark]?, Error?)> {
        return Observable.create { observer in
            self.base.geocodeAddressString(addressString, completionHandler: { (placemarks, error) in
                guard error == nil else {
                    observer.onNext((nil, error))
                    observer.onCompleted()
                    return
                }
                observer.onNext((placemarks, error))
                observer.onCompleted()
            })
            return Disposables.create()
        }
    }
}
