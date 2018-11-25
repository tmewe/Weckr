//
//  WeatherServiceType.swift
//  Weckr
//
//  Created by Tim Mewe on 23.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import RxSwift

protocol WeatherServiceType {
    func forecast(for position: GeoCoordinate) -> Observable<WeatherForecast>
}
