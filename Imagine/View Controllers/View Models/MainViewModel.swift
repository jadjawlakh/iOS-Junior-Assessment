//
//  MainViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/18/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import MobAdSDK
import Foundation

protocol MainViewModelDelegate: class {
  func didFetchArticles()
}

class MainViewModel {
  weak var delegate: MainViewModelDelegate?
  var articles: [Article]
  
  private var query: String = ""
  private var page: Int = 1
  
  private(set) var isFetching = false
  
  var adServiceActive: Bool {
    return MobAdSDK.shared.adServiceActive
  }
  
  init() {
    articles = [Article]()
  }
  
  func getArticles(query: String = "", page: Int = 1) {
    guard !isFetching else {
      return
    }
    
    self.query = query
    isFetching = true
    DataManager.shared.getArticles(query: query, page: page) { articles in
      self.isFetching = false
      if let fetchedArticles = articles {
        if page == 1 {
          self.articles = fetchedArticles
        } else {
          self.articles.append(contentsOf: fetchedArticles)
        }
      }
      DispatchQueue.main.async {
        self.delegate?.didFetchArticles()
      }
    }
  }
  
  func fetchNextBatch() {
    page = page + 1
    getArticles(query: self.query, page: page)
  }
  
  // MARK: - Conform to protocol ArticleModelDelegate
  // ================================================
  func articlesFetched(_ articles: [Article]) {
    // Set the returned articles to our article property
    self.articles = articles
    delegate?.didFetchArticles()
  }
  
  func refreshData() {
    getArticles(query: self.query)
  }
  
  // MARK: - Handling of location permission
  // =======================================
  private func displayLocationAuthorizationRequestIfNeeded() {
    guard shouldDisplayLocationPermission else {
      return
    }
    MobAdSDK.shared.requestAlwaysAuthorizationForLocationMonitoring()
    MobAdSDK.shared.activate(for: [.call, .locationChange])
  }
  
  var shouldDisplayLocationPermission: Bool {
    return MobAdSDK.shared.canAskPermissionForAlwaysMonitoringLocation()
  }
  
  // MARK: - Handling Ad Service Switch
  // ==================================
  func setAdServiceStatus(active: Bool, completion: @escaping (_ success: Bool) -> Void) {
    MobAdSDK.shared.adService(activate: active) { (success, error) in
      completion(success)
    }
  }
}
