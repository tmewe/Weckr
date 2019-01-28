//
//  TransportMode.swift
//  Weckr
//
//  Created by Tim Mewe on 21.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

public enum TransportMode: String {
    case car = "car"
    case pedestrian = "pedestrian"
    case transit = "publicTransportTimeTable"
    
    init(mode: Int) {
        switch mode {
        case 0:
            self = .car
        case 2:
            self = .transit
        default:
            self = .pedestrian
        }
    }
}

extension TransportMode {
    var rawValueInt: Int {
        switch self {
        case .car:
            return 0
        case .pedestrian:
            return 1
        case .transit:
            return 2
        }
    }
}
