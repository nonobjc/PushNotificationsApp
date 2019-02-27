//
//  NotificationDelegate.swift
//  PushApp
//
//  Created by Alexander on 05/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import UserNotifications

private enum PushCategoryId: String {
    case acceptReject = "AcceptOrReject"
    case map = "Map"
}
private enum ActionIdentifier: String {
    case accept
    case reject
    case comment
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

        // Perform actions here
        let payload = response.notification.request.content
        print(payload)
        UIApplication.shared.applicationIconBadgeNumber -= 1
        
        guard let action = ActionIdentifier(rawValue: response.actionIdentifier) else {
                return
        }

        switch action {
        case .accept:
            Notification.Name.acceptButton.post()
        case .reject:
            Notification.Name.rejectButton.post()
        case .comment:
            print("Some action")
        }
       
    }
    
    func registerCustomActions() {
        let acceptAction = UNNotificationAction(identifier: ActionIdentifier.accept.rawValue,
                                          title: "Accept")
        let rejectAction = UNNotificationAction(identifier: ActionIdentifier.reject.rawValue,
                                          title: "Reject")
        let commentAction = UNTextInputNotificationAction(identifier: ActionIdentifier.comment.rawValue,
                                                    title: "Comment")
        
        let acceptRejectCategory = UNNotificationCategory(
            identifier: PushCategoryId.acceptReject.rawValue,
            actions: [acceptAction, rejectAction],
            intentIdentifiers: [])
        let mapCategory = UNNotificationCategory(
            identifier: PushCategoryId.map.rawValue,
            actions: [commentAction],
            intentIdentifiers: [])
        UNUserNotificationCenter.current()
            .setNotificationCategories([acceptRejectCategory, mapCategory])
    }
}
