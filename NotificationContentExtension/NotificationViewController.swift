//
//  NotificationViewController.swift
//  NotificationContentExtension
//
//  Created by Jad Jawlakh on 11/4/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import MobAdSDK

class NotificationViewController: MobAdNotificationViewController {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
  override func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
    }

}
