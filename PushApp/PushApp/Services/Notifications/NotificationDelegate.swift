//
//  NotificationDelegate.swift
//  PushApp
//
//  Created by Alexander on 05/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import UserNotifications

private let categoryIdentifier = "AcceptOrReject"
private enum ActionIdentifier: String {
    case accept, reject
}

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
        
        let identity = response.notification.request.content.categoryIdentifier
        guard identity == categoryIdentifier,
            let action = ActionIdentifier(rawValue: response.actionIdentifier)
            else {
                return
        }
        
        switch action {
        case .accept:
            Notification.Name.acceptButton.post()
        case .reject:
            Notification.Name.rejectButton.post()
        }
        
        // Perform actions here
        let payload = response.notification.request.content
        print(payload.userInfo)
    }
    
    func registerCustomActions() {
        let accept = UNNotificationAction(identifier: ActionIdentifier.accept.rawValue,
                                          title: "Accept")
        let reject = UNNotificationAction(identifier: ActionIdentifier.reject.rawValue,
                                          title: "Reject")
        
        let category = UNNotificationCategory(identifier: categoryIdentifier,
                                              actions: [accept, reject],
                                              intentIdentifiers: [])
        UNUserNotificationCenter.current()
            .setNotificationCategories([category])
    }
}
