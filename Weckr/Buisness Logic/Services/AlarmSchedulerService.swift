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
import RxSwift

protocol AlarmSchedulerServiceType {
    func setAlarmNotification(with date: Date) -> Observable<Void>
    func setNoAlarmNotification() -> Observable<Void>
    func setAlarmUpdateNotification(for alarm: Alarm) -> Observable<Void>
}

struct AlarmSchedulerService: AlarmSchedulerServiceType {
    
    func setAlarmNotification(with date: Date) -> Observable<Void> {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Wake up"
        content.body = "Time to get to your first event"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "alarm.mp3"))
        
        let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components,
                                                    repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
                
        return add(request: request, to: notificationCenter)
    }
    
    func setNoAlarmNotification() -> Observable<Void> {
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
        return add(request: request, to: notificationCenter)
    }
    
    func setAlarmUpdateNotification(for alarm: Alarm) -> Observable<Void> {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let month = Formatter.Date.dayMonthLong.string(from: alarm.date)
        let time = Formatter.Date.timeShort.string(from: alarm.date)
        
        let content = UNMutableNotificationContent()
        content.title = "Oh hey"
        content.body = "I detected some changes. Your next alarm rings at \(time) on \(month)"
        content.categoryIdentifier = "update"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        return add(request: request, to: notificationCenter)
    }
    
    private func add(request: UNNotificationRequest, to center: UNUserNotificationCenter) -> Observable<Void> {
        return center.rx.add(request).debug("notification", trimOutput: true).map { _ in Void() }
    }
}
