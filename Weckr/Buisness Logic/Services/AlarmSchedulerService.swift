//
//  AlarmSchedulerService.swift
//  Weckr
//
//  Created by Tim Mewe on 12.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation

protocol AlarmSchedulerServiceProtocol {
    func setNotification(with date: Date)
}

struct AlarmSchedulerService: AlarmSchedulerServiceProtocol {
    func setNotification(with date: Date) {
        
    }
}
