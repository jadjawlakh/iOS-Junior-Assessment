//
//  AdSettingsViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/4/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation
import MobAdSDK

class AdSettingsViewModel {
  
  var adServiceActive: Bool {
    return MobAdSDK.shared.adServiceActive
  }
  
  var maximumAdsPerDay: Int {
    return MobAdSDK.shared.userMaximumAdsPerDay
  }
  
  func setMaximumAdsPerDay(cap: Int, completion: @escaping (_ success: Bool, _ maxAdsPerDay: Int?) -> Void) {
    MobAdSDK.shared.updateUserProfile(countryCode: nil, languageCode: nil, maxAdsPerDay: cap, preferredAdLanguagesCodes: nil) { (success, maxAdsPerDay, error) in
      completion(success, maxAdsPerDay)
    }
  }
  
  func setAdServiceStatus(active: Bool, completion: @escaping (_ success: Bool) -> Void) {
    MobAdSDK.shared.adService(activate: active) { (success, error) in
      completion(success)
    }
  }
  
  var shouldDisplayLocationPermission: Bool {
    return MobAdSDK.shared.canAskPermissionForAlwaysMonitoringLocation()
  }
}
