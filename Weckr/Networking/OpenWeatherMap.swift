//
//  OpenWeatherMap.swift
//  Weckr
//
//  Created by Tim Mewe on 23.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Moya

public enum OpenWeatherMap {
    static private let appId = "6fb5512c186f5afced3e5bc104eaec12"
    
    case fiveDayForecast(lat: Double, long: Double)
}

extension OpenWeatherMap: TargetType {
    public var baseURL: URL {
        return URL(string: "api.openweathermap.org/data/2.5")!
    }
    
    public var path: String {
        switch self {
        case .fiveDayForecast: return "/forecast"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .fiveDayForecast: return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case let .fiveDayForecast(value):
            return .requestParameters(parameters:[
                "lat": value.lat,
                "long": value.long,
                "units": "metric",
                "APPID": OpenWeatherMap.appId
                ], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
}
