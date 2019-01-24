//
//  RoutingService.swift
//  Weckr
//
//  Created by Tim Mewe on 24.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol RoutingServiceType {
    func route(with type: TransportMode, start: GeoCoordinate, end: GeoCoordinate, arrival: Date) -> Observable<Route>
}

struct RoutingService: RoutingServiceType {
    
    private var hereMaps: MoyaProvider<HereMaps>
    
    init(hereMaps: MoyaProvider<HereMaps>
        = MoyaProvider<HereMaps>(plugins: [NetworkLoggerPlugin(verbose: true), MoyaNetworkActivityPlugin().plugin])) {
        self.hereMaps = hereMaps
    }
    
    func route(with type: TransportMode,
               start: GeoCoordinate,
               end: GeoCoordinate,
               arrival: Date) -> Observable<Route> {
        return hereMaps.rx
            .request(.route(mode: type, start: start, end: end, arrival: arrival))
            .catchError({_ in throw AccessError.calendar})
            .map(RouteWrapper.self)
            .map { $0.routes.first }
            .asObservable()
            .filterNil()
    }
}
