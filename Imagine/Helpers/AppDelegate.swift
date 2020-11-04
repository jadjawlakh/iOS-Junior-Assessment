//
//  AppDelegate.swift
//  Imagine
//
//  Created by Marwan  on 9/19/19.
//  Copyright © 2019 Imagine Works. All rights reserved.
//

import MobAdSDK
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    MobAdSDK.shared.initializeWith(
      identifier: "m0b@ds@mpl3@pp1d",
      group: "group.com.works.imagine.Imagine")
    MobAdSDK.shared.activate()
    
    MobAdSDK.shared.initiateUser(email: nil, password: nil, countryCode: "LB", languageCode: "nil", completion: { (success, error) in
      print(success)
    })
    
    let twoHoursInSeconds: TimeInterval = 60*60*2
    application.setMinimumBackgroundFetchInterval(twoHoursInSeconds)
    
    // Register for Push Notifications
    registerForPushNotificationsIfAvailable()
    
    return true
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    MobAdSDK.shared.syncAds { result in
      completionHandler(result)
    }
  }
  
  func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
    MobAdSDK.shared.backgroundSessionCompletionHandler = completionHandler
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
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
}

// MARK: - Notification Center Delegate
// ====================================
extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    defer {
      completionHandler()
    }
    
    guard !MobAdSDK.shared.handle(response) else {
      return
    }
    // Propagate the notification handling
  }
}

// MARK: - Push Notifications
// ==========================
// Registration to APNs
// --------------------------
func application(_ application: UIApplication,
                 didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
  let token = tokenParts.joined()
  
  MobAdSDK.shared.registerRemoteNotifications(token: token, completion: nil)
}

private func registerForPushNotificationsIfAvailable() {
  UNUserNotificationCenter.current().getNotificationSettings { settings in
    guard settings.authorizationStatus == .authorized else { return }
    DispatchQueue.main.async {
      UIApplication.shared.registerForRemoteNotifications()
    }
  }
}
