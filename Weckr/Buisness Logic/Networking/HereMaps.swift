//
//  HereMaps.swift
//  Weckr
//
//  Created by Tim Mewe on 24.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation
import Moya

public enum HereMaps {
    static private let appId = "Jt2vDqlL03Qkx7t960Le"
    static private let appCode = "89VbFnAeuM24uxNsDIhdDA"
    
    case route(mode: Vehicle, start: GeoCoordinate, end: GeoCoordinate, arrival: Date)
}

extension HereMaps: TargetType {
    public var baseURL: URL {
        return URL(string: "https://route.api.here.com/routing/7.2")!
    }
    
    public var path: String {
        switch self {
        case .route:
            return "/calculateroute.json"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .route:
            return .get
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        
        var parameters:[String: Any] = [
            "app_id": HereMaps.appId,
            "app_code": HereMaps.appCode,
            "instructionFormat" : "text"
            ]
        
        switch self {
        case let .route(value):
            parameters["waypoint0"] = value.start.toString()
            parameters["waypoint1"] = value.end.toString()
            
            switch value.mode {
            case .car:
                parameters["mode"] = "fastest;car;traffic:enabled"
            case .feet:
                parameters["mode"] = "fastest;pedestrian"
            case .transit:
                parameters["mode"] = "fastest;publicTransportTimeTable"
                parameters["maneuverAttributes"] = "pt"
                parameters["arrival"] = value.arrival.xsDateTime
            }
            
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
