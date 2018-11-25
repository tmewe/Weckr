//
//  RoutingServiceType.swift
//  Weckr
//
//  Created by Tim Mewe on 24.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift

protocol RoutingServiceType {
    func route(with type: Vehicle, start: GeoCoordinate, end: GeoCoordinate, arrival: Date) -> Observable<Route>
}
