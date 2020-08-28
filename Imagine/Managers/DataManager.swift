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
  
  private var bookmarkedArticles: [Article] = [] {
    didSet {
      NotificationCenter.default.post(name: DataManager.Notification.Name.bookmarkedArticlesListUpdated, object: nil, userInfo: nil)
    }
  }
  
  func getBookmarkArticlesArray() -> [Article]? {
    return bookmarkedArticles
  }
  
  private init() {
    // Forbid instantiation of DataManager, the former can only be used through the shared instance
    guardianAPI = TheGuardianAPI()
  }
  
  func isArticleBookmarked(id: String) -> Bool {
    return bookmarkedArticles.contains(where: { article -> Bool in
      return article.articleId == id
    })
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
  
  // MARK: - Bookmarking Handlers
  // ============================
  
  func addArticleToBookmarks(articleID: String) {
    //================================
    // Implementation 1
    
//    if let specificArticle = articles?.first(where: { article -> Bool in
//      article.articleId == articleID
//    }) {
//      bookmarkedArticles.append(specificArticle)
//    } else {
//      print("else else else")
//    }
    
    //================================
    // Implementation 2
    
    guard let specificArticle = articles?.first(where: { article -> Bool in
      return article.articleId == articleID
    }) else {
      print("else else else")
      return
    }
    bookmarkedArticles.append(specificArticle)
  }
  
  func removeArticleToBookmarks(articleID: String) {
    guard let specificArticle = articles?.first(where : { article -> Bool in
      return article.articleId == articleID
    }) else {
      print("else else else")
      return
    }
    bookmarkedArticles.removeAll { article -> Bool in
      return specificArticle.articleId == articleID
    }
  }
  
  func articleForID(_ id: String) -> Article? {
    
    return articles?.first(where: { article in
      article.articleId == id
    })
  }
  
//  func getBookmarkedArticles(completionBlock: @escaping (_ articles: [Article]?) -> Void) {
//
//  }
}

extension DataManager {
  struct Notification {
    struct Name {
      static let articlesListUpdated = NSNotification.Name("articlesListUpdated")
      static let bookmarkedArticlesListUpdated = NSNotification.Name("bookmarkedArticlesListUpdated")
    }
  }
}
