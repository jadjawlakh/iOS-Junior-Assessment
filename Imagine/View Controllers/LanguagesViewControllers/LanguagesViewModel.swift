//
//  LanguagesViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/5/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation
import MobAdSDK

typealias LanguagesRowInfo = (title: String, subtitle: String, isSelected: Bool)

class LanguagesViewModel {
  private(set) var sdkLanguages = [Language]()
  private(set) var userLanguages = [String]() // Languages codes
  
  // MARK: Persist Changes
  //======================
  func save(completion: @escaping (_ success: Bool) -> Void) {
    MobAdSDK.shared.updateUserProfile(countryCode: nil, languageCode: nil, maxAdsPerDay: nil, preferredAdLanguagesCodes: userLanguages) { (success, _, error) in
      completion(success)
    }
  }
  
  // MARK: - Loading Data
  // ====================
  func loadLanguages(completion: @escaping (_ success: Bool) -> Void) {
    let group = DispatchGroup()
    var successFetchSupportedLanguages = false
    var successFetchUserLanguages = false
    
    group.enter()
    loadSupportedLanguages { (success) in
      successFetchSupportedLanguages = success
      group.leave()
    }
    group.enter()
    loadUserLanguages { (success) in
      successFetchUserLanguages = success
      group.leave()
    }
    group.notify(queue: .main) {
      completion(successFetchSupportedLanguages && successFetchUserLanguages)
    }
  }
  
  private func loadSupportedLanguages(completion: @escaping (_ success: Bool) -> Void) {
    MobAdSDK.shared.getSupportedLanguages { (success, languages, error) in
      defer {
        completion(success)
      }
      guard let languages = languages else {
        return
      }
      self.sdkLanguages = languages
    }
  }
  
  private func loadUserLanguages(completion: @escaping (_ success: Bool) -> Void) {
    userLanguages = MobAdSDK.shared.preferredAdLanguages
    completion(true)
  }
  
  // MARK: - Table View Functionalities
  // ==================================
  func numberOfRows(in section: Int) -> Int {
    return sdkLanguages.count
  }
  
  var numberOfSections: Int {
    return sdkLanguages.count > 0 ? 1 : 0
  }
  
  func informationForCell(at indexPath: IndexPath) -> LanguagesRowInfo? {
    let language = sdkLanguages[indexPath.row]
    let title = language.name ?? ""
    let subtitle = language.nativeName ?? ""
    let isSelected = userLanguages.contains(language.code ?? "")
    return (title, subtitle, isSelected)
  }
  
  func canDeselectLanguage(at indexPath: IndexPath) -> Bool {
    return userLanguages.count > 1
  }
  
  func selectLanguage(at indexPath: IndexPath) -> Bool {
    guard let code = sdkLanguages[indexPath.row].code else {
      return false
    }
    userLanguages.append(code)
    return true
  }
  
  func deselectLanguage(at indexPath: IndexPath) -> Bool {
    guard let code = sdkLanguages[indexPath.row].code else {
      return false
    }
    userLanguages.removeAll { $0 == code }
    return true
  }
  
}
