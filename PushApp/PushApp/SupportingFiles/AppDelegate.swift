//
//  AppDelegate.swift
//  PushApp
//
//  Created by Alexander on 03/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let options: UNAuthorizationOptions = [.badge,
                                               .sound,
                                               .alert
        ]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, _ in
            guard granted else {
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
        
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.reduce("") { $0 + String(format: "%02x", $1) }
        print(token)
    }
}

