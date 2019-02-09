//
//  AppDelegate+PushExtension.swift
//  PushApp
//
//  Created by Alexander on 08/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

extension AppDelegate {
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        sendPushNotificationDetails(to: "http://192.168.228.228:8080/api/token",
                                    using: deviceToken)
    }
    
    // Content-available (Foreground & Bachground)
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        guard let text = userInfo["text"] as? String,
            let image = userInfo["image"] as? String,
            let url = URL(string: image) else {
                completionHandler(.noData)
                return
        }
        
        let context = coreDataStack.managedContext
        context.perform {
            do {
                let message = Message(context: context)
                message.image = try Data(contentsOf: url)
                message.received = Date()
                message.text = text
                try context.save()
                completionHandler(.newData)
            } catch {
                completionHandler(.failed)
            }
        }
    }
    
    func registerForPushNotifications(application: UIApplication) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.badge, .sound, .alert]) { [weak self] granted, _ in
            
            guard granted else {
                return
            }
            
            center.delegate = self?.notificationDelegate
            
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }
    
    func sendPushNotificationDetails(to urlString: String,
                                     using deviceToken: Data) {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL string")
        }
        
        let token = deviceToken.reduce("") {
            $0 + String(format: "%02x", $1)
        }
        
        var obj: [String: Any] = [
            "token": token,
            "debug": false
        ]
        
        #if DEBUG
        obj["debug"] = true
        #endif
        
        var request = URLRequest(url: url)
        request.addValue("application/json",
                         forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = try! JSONSerialization.data(withJSONObject: obj)
        
        #if DEBUG
        print("Device Token: \(token)")
        
        let pretty = try! JSONSerialization.data(withJSONObject: obj,
                                                 options: .prettyPrinted)
        print(String(data: pretty, encoding: .utf8)!)
        #endif
        
        URLSession.shared.dataTask(with: request).resume()
    }
}
