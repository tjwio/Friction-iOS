//
//  AppDelegate.swift
//  friction
//
//  Created by Tim Wong on 11/18/18.
//  Copyright © 2018 tjwio. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import HockeySDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    private struct Constants {
        struct Hockey {
            static let id = "ccbae485c4064ef6a7da864d31c9a072"
        }
    }

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        BITHockeyManager.shared().configure(withIdentifier: Constants.Hockey.id)
        BITHockeyManager.shared().start()
        BITHockeyManager.shared().authenticator.authenticateInstallation()
        
        FirebaseApp.configure()
        
        registerForPushNotifications()
        CommonUtility.configureMessages()
        
        loadMainViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func loadMainViewController() {
        var rootViewController: UIViewController
        
        if AuthenticationManager.shared.authToken?.isEmpty ?? true || AuthenticationManager.shared.userId?.isEmpty ?? true {
            rootViewController = UINavigationController(rootViewController: WelcomeViewController())
        } else {
            rootViewController = UINavigationController(rootViewController: MainViewController())
        }
        
        window?.rootViewController = rootViewController
    }
    
    // MARK: push notifications
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        print("Device Token: \(token)")
        
        guard UserDefaults.standard.string(forKey: AppConstants.UserDefaults.tokenKey) != token, let udid = UIDevice.current.identifierForVendor?.uuidString,
            let userId = AuthenticationManager.shared.userId else { return }
        
        let params: JSON = [
            DeviceToken.CodingKeys.token.rawValue: token,
            DeviceToken.CodingKeys.udid.rawValue: udid,
            DeviceToken.CodingKeys.userId.rawValue: userId
        ]
        
        NetworkHandler.shared.addToken(parameters: params, success: { _ in
            UserDefaults.standard.set(token, forKey: AppConstants.UserDefaults.tokenKey)
        }, failure: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }
}

