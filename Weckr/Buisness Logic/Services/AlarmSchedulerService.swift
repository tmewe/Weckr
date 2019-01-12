//
//  AlarmSchedulerService.swift
//  Weckr
//
//  Created by Tim Mewe on 12.01.19.
//  Copyright © 2019 Tim Lehmann. All rights reserved.
//

import Foundation
import UserNotifications
import SwiftDate

protocol AlarmSchedulerServiceProtocol {
    func setNotification(with date: Date)
}

struct AlarmSchedulerService: AlarmSchedulerServiceProtocol {
    func setNotification(with date: Date) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Wake up"
        content.body = "Time to get to your first event"
        content.sound = .default
        
        let testDate = Date() + 10.seconds
        let trigger = UNCalendarNotificationTrigger(dateMatching: testDate.dateComponents,
                                                    repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
}
