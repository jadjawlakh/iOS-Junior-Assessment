//
//  DetailViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/18/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

protocol DetailViewModelDelegate: class {
  // Used later for the bookmark feature
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
    return article?.isBookmarked ?? false
  }
  
  func toggleArticleBookmarkStatus() {
    guard let id = article?.articleId else {
      return
    }
    guard DataManager.shared.toggleBookmarkStatusForArticleWithID(id) else {
      return
    }
    refreshViewModelData()
  }
  
  private func refreshViewModelData() {
    guard let id = article?.articleId else {
      return
    }
    article = DataManager.shared.articleForID(id)
  }
}
