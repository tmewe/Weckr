//
//  RouteWrapper.swift
//  Weckr
//
//  Created by Tim Mewe on 24.11.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

struct RouteWrapper: Decodable {
    var routes: [Route] = []
    
    enum CodingKeys: String, CodingKey {
        case routes = "route"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        routes = try container.decode([Route].self, forKey: .routes)
    }
}
