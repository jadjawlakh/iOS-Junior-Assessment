//
//  DataManager.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/20/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

class DataManager {
  static let shared = DataManager()
  var guardianAPI: TheGuardianAPI
  private var articles: [Article]? {
    didSet {
      NotificationCenter.default.post(name: DataManager.Notification.Name.articlesListUpdated, object: nil, userInfo: nil)
    }
  }
  
  private var bookmarkedArticles: [Article]? {
    didSet {
      NotificationCenter.default.post(name: DataManager.Notification.Name.bookmarkedArticlesListUpdated, object: nil, userInfo: nil)
    }
  }
  
//  private var bookmarkedArticles = [String]()
  
  private init() {
    // Forbid instantiation of DataManager, the former can only be used through the shared instance
    guardianAPI = TheGuardianAPI()
  }
  
  func getArticles(searching: Bool, completionBlock: @escaping (_ articles: [Article]?) -> Void) {
    /*
     If articles are already fetched and referenced through the 'articles' variable
     no need to do the API call.
     */
    guard articles == nil || searching == true else {
      completionBlock(articles)
      return
    }
    guardianAPI.getArticles { returnedArticles in
      self.articles = returnedArticles
      completionBlock(returnedArticles)
    }
  }
  
  func toggleBookmarkStatusForArticleWithID(_ id: String) -> Bool {
    guard let indexOfArticle = articles?.firstIndex(where: { $0.articleId == id }) else {
      return false
    }
    let originalBookmarkStatus = articles?[indexOfArticle].isBookmarked ?? false
    articles?[indexOfArticle].isBookmarked = !originalBookmarkStatus
    return true
  }
  
  func articleForID(_ id: String) -> Article? {
    return articles?.first(where: { article in
      article.articleId == id
    })
  }
  
  func returnBookmarkedArticles() -> Article? {
    return articles?.first(where: { article in
         article.isBookmarked == true
       })
  }
  
}


extension DataManager {
  struct Notification {
    struct Name {
      static let articlesListUpdated = NSNotification.Name("articlesListUpdated")
      static let bookmarkedArticlesListUpdated = NSNotification.Name("bookmarkedArticlesListUpdated")
    }
  }
}
