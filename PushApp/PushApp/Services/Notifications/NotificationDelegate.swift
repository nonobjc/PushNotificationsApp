//
//  NotificationDelegate.swift
//  PushApp
//
//  Created by Alexander on 05/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import UserNotifications

final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    
    // Foreground (Content-available and not)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge])
    }
    
    // When you tap notification
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        defer { completionHandler() }
        
        guard response.actionIdentifier == UNNotificationDefaultActionIdentifier else {
            return
        }
        
        // Perform actions here
        let payload = response.notification.request.content
        print(payload.userInfo)
    }
}
