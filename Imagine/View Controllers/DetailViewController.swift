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
    
    // Observe the notification
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshDataList),
      name: DataManager.Notification.Name.bookmarkedArticlesListUpdated,
      object: nil)    
  }
  
  // MARK: - ACTIONS
  // ================
  @objc func bookmarkButtonTouchUpInside(_ sender: UIButton) {
    viewModel.toggleArticleBookmarkStatus()
    refreshBookmarkButton()
  }
  
  @IBAction func shareButtonPressed(_ sender: Any) {
    let activityVC = UIActivityViewController(activityItems: ["https://theguardian.com/\(viewModel.articleId)"], applicationActivities: nil)
      activityVC.popoverPresentationController?.sourceView = self.view
      
      self.present(activityVC, animated: true, completion: nil)
  }
  
  // MARK: - HELPERS
  // ===============
  func refreshBookmarkButton() {
    bookmarkButton.isBookmarked = viewModel.isBookmarked
  }
  
  // MARK: - Notification Handler
  //=============================
  @objc private func refreshDataList() {
    viewModel.refreshData(button: bookmarkButton)
  }
}

