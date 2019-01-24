//
//  MoyaNetworkActivityPlugin.swift
//  Weckr
//
//  Created by Tim Mewe on 24.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import Moya
import BOTNetworkActivityIndicator

class MoyaNetworkActivityPlugin {
    
    let plugin: NetworkActivityPlugin
    
    init() {
        plugin = NetworkActivityPlugin(networkActivityClosure:  { change, _ in
            switch change {
            case .began: BOTNetworkActivityIndicator.shared()?.pushNetworkActivity()
            case .ended: BOTNetworkActivityIndicator.shared()?.popNetowrkActivity()
            }
        })
    }
}
