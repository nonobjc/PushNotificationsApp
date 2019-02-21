//
//  NotificationService.swift
//  PayloadModification
//
//  Created by Alexander on 19/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest,
                             withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content
            bestAttemptContent.title = ROT228.shared.decrypt(bestAttemptContent.title)
            bestAttemptContent.body = ROT228.shared.decrypt(bestAttemptContent.body)
            
            if let urlPath = request.content.userInfo["media-url"] as? String,
                let url = URL(string: ROT228.shared.decrypt(urlPath)) {
                
                let destination = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(url.lastPathComponent)
                
                do {
                    let data = try Data(contentsOf: url)
                    try data.write(to: destination)
                    
                    let attachment = try UNNotificationAttachment(identifier: "",
                                                                  url: destination)
                    bestAttemptContent.attachments = [attachment]
                } catch {
                }
            }
            
            if let badgeValue = bestAttemptContent.badge as? Int {
                switch badgeValue {
                case 0:
                    UserDefaults.extensions.badge = 0
                    bestAttemptContent.badge = 0
                default:
                    let current = UserDefaults.extensions.badge
                    let new = current + badgeValue

                    UserDefaults.extensions.badge = new
                    bestAttemptContent.badge = NSNumber(value: new)
                }
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}
