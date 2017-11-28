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
        setupActionsAndCategories()
    }
    
    func setupActionsAndCategories() {
        let timerAction = UNNotificationAction(identifier: NotificationActionID.timer.rawValue, title: "Run timer logic", options: [.authenticationRequired])
        let dateAction = UNNotificationAction(identifier: NotificationActionID.date.rawValue, title: "Run some date logic", options: [.destructive])
        let locationAction = UNNotificationAction(identifier: NotificationActionID.location.rawValue, title: "Run some location logic", options: [.foreground])
        
        let timerCategory = UNNotificationCategory(identifier: NotificationCategory.timer.rawValue, actions: [timerAction], intentIdentifiers: [])
        let dateCategory = UNNotificationCategory(identifier: NotificationCategory.date.rawValue, actions: [dateAction], intentIdentifiers: [])
        let locationCategory = UNNotificationCategory(identifier: NotificationCategory.location.rawValue, actions: [locationAction], intentIdentifiers: [])
        
        unCenter.setNotificationCategories([timerCategory, dateCategory, locationCategory])
    }
    
    func getAttachement(for id: NotificationAttachmentID) -> UNNotificationAttachment? {
        var imageName: String
        switch id {
        case .timer:
            imageName = "TimeAlert"
        case .date:
            imageName = "DateAlert"
        case .location:
            imageName = "LocationAlert"
        }
        
        guard let url = Bundle.main.url(forResource: imageName, withExtension: "png") else { return nil }
        
        do {
           let attachment = try UNNotificationAttachment(identifier: id.rawValue, url: url)
            return attachment
        } catch {
            return nil
        }
        
    }
    
    func requestTimerNotification(with interval: TimeInterval) {
        var content = UNMutableNotificationContent()
        
        setupContentWith(title: "Timer finished", body: "Your timer is done. Time to kick some ass!", sound: .default(), badge: 1, content: &content, attachmentID: .timer, categoryIdentifier: .timer)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
        let request = UNNotificationRequest(identifier: UserNotif.timer.rawValue, content: content, trigger: trigger)
        
        unCenter.add(request, withCompletionHandler: nil)
    }
    
    func requestDateNotification(with components: DateComponents) {
        var content = UNMutableNotificationContent()
        
        setupContentWith(title: "Date Trigger", body: "It is now the future", sound: .default(), badge: 1, content: &content, attachmentID: .date, categoryIdentifier: .date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: UserNotif.date.rawValue, content: content, trigger: trigger)
        
        unCenter.add(request, withCompletionHandler: nil)
        
    }
    
    func requestLocationNotification() {
        var content = UNMutableNotificationContent()
        
        setupContentWith(title: "You have returned!", body: "Welcome back to where you started your journey", sound: .default(), badge: 1, content: &content, attachmentID: .location, categoryIdentifier: .location)
        let request = UNNotificationRequest(identifier: "userNotification.location", content: content, trigger: nil)
        unCenter.add(request)
    }
    
    func setupContentWith(title: String, body: String, sound: UNNotificationSound, badge: NSNumber, content: inout UNMutableNotificationContent, attachmentID: NotificationAttachmentID, categoryIdentifier: NotificationCategory) {
        content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = sound
        content.badge = badge
        content.categoryIdentifier = categoryIdentifier.rawValue
        
        if let attachment = getAttachement(for: attachmentID) {
            content.attachments = [attachment]
        }
    }
    
}

//MARK: UNUserNotificationCenterDelegate

extension UNService: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("UN did receive response")
        
        if let action = NotificationActionID(rawValue: response.actionIdentifier) {
            NotificationCenter.default.post(name: NSNotification.Name("internalNotification.handleAction"), object: action)
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("UN will present")
        
        let options: UNNotificationPresentationOptions = [.alert, .sound]
        completionHandler(options)
    }
}






