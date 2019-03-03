//
//  UNUserNotificationCenter+Helper.swift
//  friction
//
//  Created by Tim Wong on 3/2/19.
//  Copyright © 2019 tjwio. All rights reserved.
//

import UIKit
import UserNotifications

extension UNUserNotificationCenter {
    func requestAuthorizationStatus() {
        requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}
