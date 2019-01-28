//
//  Array+Extensions.swift
//  Weckr
//
//  Created by Tim Mewe on 22.12.18.
//  Copyright © 2018 Tim Lehmann. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == String {
    public func naturalJoined() -> String {
        return self.joined(separator: " ")
    }
}
