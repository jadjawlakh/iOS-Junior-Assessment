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
  
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let defaults = UserDefaults.standard
  
  var isPaginating = false
  
  var searchQuery = ""
  
  private var bookmarkedArticles: [Article] = [] {
    didSet {
      NotificationCenter.default.post(name: DataManager.Notification.Name.bookmarkedArticlesListUpdated, object: nil, userInfo: nil)
      saveBookmarkedArticles()
    }
  }
  
  private init() {
    bookmarkedArticles = readBookmarkedArticles() ?? []
  }
  
  func getBookmarkArticlesArray() -> [Article]? {
    return bookmarkedArticles
  }
  
  private func saveBookmarkedArticles() {
    guard let encoded = try? encoder.encode(bookmarkedArticles) else {
      return
    }
    defaults.set(encoded, forKey: "SavedArticle")
  }
  
  private func readBookmarkedArticles() -> [Article]? {
    guard let savedArticlesData = defaults.object(forKey: "SavedArticle") as? Data else {
      return nil
    }
    guard let loadedArticles = try? decoder.decode([Article].self, from: savedArticlesData) else {
      return nil
    }
    return loadedArticles
  }
  
  func isArticleBookmarked(id: String) -> Bool {
    return bookmarkedArticles.contains(where: { article -> Bool in
      return article.articleId == id
    })
  }
  
  func getArticles(query: String, page: Int, completionBlock: @escaping (_ articles: [Article]?) -> Void) {
    TheGuardianAPI.getArticles(query: query, page: page) { articles in
      completionBlock(articles)
    }
  }
  
  // MARK: - Bookmarking Handlers
  // ============================
  
  func addArticleToBookmarks(_ article: Article) {
    guard !(bookmarkedArticles.contains { $0.articleId == article.articleId }) else {
      return
    }
    bookmarkedArticles.append(article)
  }
  
  func removeArticleFromBookmarks(articleID: String) {
    guard let index = bookmarkedArticles.firstIndex(where: { article -> Bool in
      return article.articleId == articleID
    }) else {
      print("not found")
      return
    }
    bookmarkedArticles.remove(at: index)
    
    // OR: IMPLEMENTATION 2
    //    bookmarkedArticles.removeAll { article -> Bool in
    //      return article.articleId == articleID
    //    }
  }
}

extension DataManager {
  struct Notification {
    struct Name {
      static let bookmarkedArticlesListUpdated = NSNotification.Name("bookmarkedArticlesListUpdated")
    }
  }
}
