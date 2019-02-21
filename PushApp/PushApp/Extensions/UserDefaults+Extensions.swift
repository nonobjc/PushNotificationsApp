//
//  UserDefaults+Extensions.swift
//  PushApp
//
//  Created by Alexander on 21/02/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import Foundation

extension UserDefaults {

    static let suiteName = "group.IBAction.PushApp"
    static let extensions = UserDefaults(suiteName: suiteName)!
    
    private enum Keys {
        static let badge = "badge"
    }
    
    var badge: Int {
        get {
            return UserDefaults.extensions.integer(forKey: Keys.badge)
        }
        
        set {
            UserDefaults.extensions.set(newValue, forKey: Keys.badge)
        }
    }
}
