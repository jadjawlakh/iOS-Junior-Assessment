//
//  BookmarkViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/19/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

protocol BookmarkViewModelDelegate: class {
  func didFetchBookmarkedArticles()
}

class BookmarkViewModel {
  weak var delegate: BookmarkViewModelDelegate?
  var bookmarkedArticles: [Article]
  
  init() {
    bookmarkedArticles = [Article]()
  }
  
  func getBookmarkedArticles() {
    bookmarkedArticles = DataManager.shared.getBookmarkArticlesArray() ?? []
    self.delegate?.didFetchBookmarkedArticles()
  }
  
  var bookmarkedArticlesCount: Int {
    guard let count = DataManager.shared.getBookmarkArticlesArray()?.count else {
      return 0
    }
    return count
  }
  
  func articleForRow(_ index: Int) -> Article? {
    return bookmarkedArticles[index]
  }
  
  // MARK: - Conform to Protocol
  
  func bookmarkedArticlesFetched(_ articles: [Article]) {
    self.bookmarkedArticles = articles
    delegate?.didFetchBookmarkedArticles()
  }
  
  func refreshData() {
    getBookmarkedArticles()
  }
}

