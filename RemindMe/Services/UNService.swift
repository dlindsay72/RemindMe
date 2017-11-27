//
//  UNService.swift
//  RemindMe
//
//  Created by Dan Lindsay on 2017-11-23.
//  Copyright © 2017 Dan Lindsay. All rights reserved.
//

import UIKit
import UserNotifications

class UNService: NSObject {
    
    private override init() {}
    
    static let shared = UNService()
    
    let unCenter = UNUserNotificationCenter.current()
    
    func authorize() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        unCenter.requestAuthorization(options: options) { (granted, error) in
            guard granted else {
                print("USER DENIED ACCESS")
                return
            }
            
            self.configure()
        }
    }
    
    func configure() {
        unCenter.delegate = self
    }
    
    func requestTimerNotification(with interval: TimeInterval) {
        var content = UNMutableNotificationContent()
        
        setupContentWith(title: "Timer finished", body: "Your timer is done. Time to kick some ass!", sound: .default(), badge: 1, content: &content)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UserNotif.timer.rawValue, content: content, trigger: trigger)
        
        unCenter.add(request, withCompletionHandler: nil)
    }
    
    func requestDateNotification(with components: DateComponents) {
        var content = UNMutableNotificationContent()
        
        setupContentWith(title: "Date Trigger", body: "It is now the future", sound: .default(), badge: 1, content: &content)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: UserNotif.date.rawValue, content: content, trigger: trigger)
        
        unCenter.add(request, withCompletionHandler: nil)
        
    }
    
    func requestLocationNotification() {
        var content = UNMutableNotificationContent()
        
        setupContentWith(title: "You have returned!", body: "Welcome back to where you started your journey", sound: .default(), badge: 1, content: &content)
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
    }
    
    func setupContentWith(title: String, body: String, sound: UNNotificationSound, badge: NSNumber, content: inout UNMutableNotificationContent) {
        content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.badge = badge
    }
    
}

//MARK: UNUserNotificationCenterDelegate

extension UNService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}






