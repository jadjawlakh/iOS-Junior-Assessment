//
//  MainViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/18/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import MobAdSDK
import Foundation

// MARK: -  MainViewModel Protocol and MainViewModel Class
// Protocol needs to conform by a class
protocol MainViewModelDelegate: class {
  func didFetchArticles()
}

class MainViewModel {
  weak var delegate: MainViewModelDelegate?
  var articles: [Article]
  
  private var query: String = ""
  private var page: Int = 1
  
  private(set) var isFetching = false
  
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
      self.delegate?.didFetchArticles()
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
}
