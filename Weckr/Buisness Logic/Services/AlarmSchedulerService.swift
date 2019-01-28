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
        content.title = Strings.Notifications.alarm.title
        content.body = Strings.Notifications.alarm.message
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
        content.title = Strings.Notifications.noEvents.title
        content.body = Strings.Notifications.noEvents.message
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
        let strings = Strings.Notifications.changes.self
        content.title = strings.title
        content.body =  strings.message + time + strings.on + month
        content.categoryIdentifier = "update"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)
        return add(request: request, to: notificationCenter)
    }
    
    private func add(request: UNNotificationRequest, to center: UNUserNotificationCenter) -> Observable<Void> {
        return center.rx.add(request).map { _ in Void() }
    }
}
