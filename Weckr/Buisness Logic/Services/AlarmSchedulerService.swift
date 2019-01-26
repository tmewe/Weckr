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

protocol AlarmSchedulerServiceType {
    func setAlarmNotification(with date: Date)
    func setNoAlarmNotification()
}

struct AlarmSchedulerService: AlarmSchedulerServiceType {
    func setAlarmNotification(with date: Date) {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Wake up"
        content.body = "Time to get to your first event"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm.mp3"))
        
//        let alarmTime = Date() + 61.seconds
        let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
                
        add(request: request, to: notificationCenter)
    }
    
    func setNoAlarmNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Attention"
        content.body = "I couldn't find any events in the upcoming week, so I won't wake you in the morning!"
        content.categoryIdentifier = "warning"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        add(request: request, to: notificationCenter)
    }
    
    private func add(request: UNNotificationRequest, to center: UNUserNotificationCenter) {
        center.add(request) { (error) in
            if error != nil {
                log.error(error!.localizedDescription)
            }
        }
    }
}
