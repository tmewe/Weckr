//
//  WeatherService.swift
//  Weckr
//
//  Created by Tim Mewe on 23.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift
import Moya

struct WeatherService: WeatherServiceType {
    
    private var openWeatherMap: MoyaProvider<OpenWeatherMap>
    
    init(openWeatherMap: MoyaProvider<OpenWeatherMap>
        = MoyaProvider<OpenWeatherMap>(plugins: [NetworkLoggerPlugin(verbose: false)])) {
        self.openWeatherMap = openWeatherMap
    }
    
    func forecast(for position: GeoCoordinate) -> Observable<WeatherForecast> {
        return openWeatherMap.rx
            .request(.fiveDayForecast(lat: position.latitude, long: position.longitude))
            .map(WeatherForecast.self)
            .asObservable()
    }
}
