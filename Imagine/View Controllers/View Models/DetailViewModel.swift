//
//  DetailViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/18/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

protocol DetailViewModelDelegate: class {
}

class DetailViewModel {
  weak var delegate: DetailViewModelDelegate?
  var article: Article? {
    didSet {
      print("Article Set")
    }
  }
  
  var title: String {
    return article?.title ?? ""
  }
  
  var publicationDate: String {
    let df = DateFormatter()
    df.dateFormat = "EEEE, MMM d, yyyy"
    guard let publishDate = article?.published else {
      return ""
    }
    return df.string(from: publishDate)
  }
  
  var request: URLRequest? {
    // Create the embed URL
    let embedUrlString = Constants.TG_EMBED_URL + (article?.articleId ?? "")
    // Load it into the WebView
    guard let url = URL(string: embedUrlString) else {
      return nil
    }
    return URLRequest(url: url)
  }
  
  var isBookmarked: Bool {
    guard let id = article?.articleId else {
      return false
    }
    return DataManager.shared.isArticleBookmarked(id: id)
  }
  
  func toggleArticleBookmarkStatus() {
    guard let article = self.article else {
      return
    }
    
    if isBookmarked {
      DataManager.shared.removeArticleFromBookmarks(articleID: article.articleId)
    } else {
      DataManager.shared.addArticleToBookmarks(article)
    }
  }
}
