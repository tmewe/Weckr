//
//  Reusable.swift
//  ChatAnalyzer
//
//  Created by Tim Mewe on 21.03.18.
//  Copyright © 2018 Tim Mewe. All rights reserved.
//

import Foundation

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
