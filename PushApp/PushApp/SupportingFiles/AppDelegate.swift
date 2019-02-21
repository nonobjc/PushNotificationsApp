//
//  AppDelegate.swift
//  PushApp
//
//  Created by Alexander on 03/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let notificationDelegate = NotificationDelegate()
    lazy var coreDataStack = CoreDataStack()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        registerForPushNotifications(application: application)
        
        return true
    }
}
