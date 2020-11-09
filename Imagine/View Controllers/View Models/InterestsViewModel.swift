//
//  PreferencesViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/5/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation
import MobAdSDK

typealias InterestsRowInfo = (title: String, isSelected: Bool)

class InterestsViewModel {
  private var interests: Interests? = nil
  private var userInterestsIDs: [Int]? = nil
  
  var viewControllerTitle: String {
    return "Interests"
  }
  
  func loadInterests(completion: @escaping (_ success: Bool) -> Void) {
    let dispatchGroup = DispatchGroup()
    var allInterestsLoadSuccessfully = false
    var userInterestsLoadSuccessfully = false
    
    dispatchGroup.enter()
    loadAllInterests { success in
      allInterestsLoadSuccessfully = success
      dispatchGroup.leave()
    }
    dispatchGroup.enter()
    loadUserInterests { success in
      userInterestsLoadSuccessfully = success
      dispatchGroup.leave()
    }
    
    dispatchGroup.notify(queue: .main) {
      completion(allInterestsLoadSuccessfully && userInterestsLoadSuccessfully)
    }
  }
  
  private func loadAllInterests(completion: @escaping (_ success: Bool) -> Void) {
    MobAdSDK.shared.allInterests { (interests, error) in
      var isSuccessful = false
      defer {
        completion(isSuccessful)
      }
      
      guard error == nil else {
        return
      }
      
      self.interests = interests
      isSuccessful = true
    }
  }
  
  private func loadUserInterests(completion: @escaping (_ success: Bool) -> Void) {
    MobAdSDK.shared.getUserInterests { (success, subcategoriesIDs, error) in
      var isSuccessful = false
      defer {
        completion(isSuccessful)
      }
      
      guard error == nil else {
        return
      }
      
      self.userInterestsIDs = subcategoriesIDs
      isSuccessful = true
    }
  }
  
  var numberOfSections: Int {
    return interests?.allCategories().count ?? 0
  }
  
  func numberOfRowsIn(section: Int) -> Int {
    return interests?.subcategories(forCategoryIndex: section).count ?? 0
  }
  
  func titleForHeaderInSection(_ section: Int) -> String {
    return interests?.category(forIndex: section).name ?? "Subcategories"
  }
  
  func informationForCellAtIndexPath(_ indexPath: IndexPath) -> InterestsRowInfo? {
    guard let subcat = subcategory(for: indexPath) else {
      return nil
    }
    let isUserInterest = userInterestsIDs?.contains(where: { $0 == subcat.id }) ?? false
    return (title: subcat.name ?? "", isSelected: isUserInterest)
  }
  
  func subcategory(for indexPath: IndexPath) -> Subcategory? {
    return interests?.subcategory(for: indexPath)
  }
  
  func selectUserInterest(at indexPath: IndexPath) -> Bool {
    guard let subcategoryID = subcategory(for: indexPath)?.id else {
      return false
    }
    userInterestsIDs?.append(subcategoryID)
    return true
  }
  
  func deselectUserInterest(at indexPath: IndexPath) -> Bool {
    guard let subcategory = subcategory(for: indexPath) else {
      return false
    }
    userInterestsIDs?.removeAll(where: { $0 == subcategory.id })
    return true
  }
  
  func selectAllSubcategories() {
    guard let subcategoriesIDs = interests?.allSubcategories().compactMap({ $0.id }) else {
      return
    }
    userInterestsIDs = subcategoriesIDs
  }
  
  func deselectAllSubcategories() {
    userInterestsIDs?.removeAll()
  }
  
  func saveChanges(completion: @escaping (_ success: Bool) -> Void) {
    guard let selectedSubcategoriesIds = userInterestsIDs else {
      completion(false)
      return
    }
    MobAdSDK.shared.setUserInterests(subcategoriesIds: selectedSubcategoriesIds) { success, error in
      completion(success)
    }
  }
}
