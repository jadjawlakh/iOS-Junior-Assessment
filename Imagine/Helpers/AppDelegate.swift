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
  
  private var adBackgrounFetchResult: UIBackgroundFetchResult?
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let isHandledByMobAdSDK = MobAdSDK.shared.handleRemoteNotification(userInfo) { result in
      completionHandler(result ?? .failed)
    }
    
    if isHandledByMobAdSDK {
      scheduleNotificationForSilentPush()
    } else {
      // Proceed
    }
  }
}

extension AppDelegate {
  func scheduleNotification(identifier: String, content: UNNotificationContent) {
    // find out what are the user's notification preferences
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      // we're only going to create and schedule a notification
      // if the user has kept notifications authorized for this app
      guard settings.authorizationStatus == .authorized else {
        return
      }
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
      let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
  }
  
  func scheduleNotificationForSilentPush() {
    let content = UNMutableNotificationContent()
    content.title = "😶 Silent 🔇 Push 🔕"
    content.body = "🏋🏻🏋️🏋🏼🏋🏽🏋🏾🏋🏿"
    content.subtitle = "True Story 😊"
    content.sound = UNNotificationSound.default
    scheduleNotification(identifier: "s1l3nt", content: content)
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
