//
//  DetailViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, DetailViewModelDelegate {
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var bookmarkButton: BookmarkButton!
  
  var viewModel = DetailViewModel()
  
  func initWithArticle(_ article: Article) {
    viewModel.article = article
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Safe unwrapping into a new variable
    if let request = viewModel.request {
      webView.load(request)
    }
    // Set the title
    titleLabel.text = viewModel.title
    // Set the date
    dateLabel.text = viewModel.publicationDate
    
    bookmarkButton.addTarget(
      self,
      action: #selector(bookmarkButtonTouchUpInside(_:)),
      for: UIControl.Event.touchUpInside)
    
    refreshBookmarkButton()
  }
  
  // MARK: - ACTIONS
  // ================
  @objc func bookmarkButtonTouchUpInside(_ sender: UIButton) {
    viewModel.toggleArticleBookmarkStatus()
    refreshBookmarkButton()
  }
  
  // MARK: - HELPERS
  // ===============
  func refreshBookmarkButton() {
    bookmarkButton.isBookmarked = viewModel.isBookmarked
  }
}

//guard viewModel.article?.isBookmarked != nil else {
//  return
//}
//
//activateButton(bool: !(viewModel.article!.isBookmarked))
//
//
//
//
//func activateButton(bool :Bool) {
//  viewModel.article!.isBookmarked = bool
//  let booleanDict: [String: Bool] = ["isArticleBookmarked" : viewModel.article!.isBookmarked]
//  let title = bool ? "Remove from bookmarks" : "Add to bookmarks"
//  bookmarkButton.setTitle(title, for: .normal)
//  NotificationCenter.default.post(name: Notification.Name("BookmarkButtonPressed"),
//                                  object: nil, userInfo: booleanDict)
//}
//
//
//
//@objc func notificationReceived(_ notification: NSNotification) {
//  print(notification.userInfo ?? "")
//  if let dict = notification.userInfo as NSDictionary? {
//    if let isArticleBookmarked = dict["isArticleBookmarked"] as? Bool {
//      // do something with your bool
//      print(isArticleBookmarked)
//    }
//  }
//}
