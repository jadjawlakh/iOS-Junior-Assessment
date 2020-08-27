//
//  BookmarkViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/19/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class BookmarkViewController: UITableViewController, BookmarkViewModelDelegate {
  let viewModel = BookmarkViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Link the BookmarkViewController to the BookmarkViewModel
    viewModel.delegate = self
    // Set itself as the data source and the delegate
    tableView.dataSource = self
    tableView.delegate = self
    // Fetch the bookmarked articles
    viewModel.getBookmarkedArticles()
    // Observe the notification
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshData),
      name: DataManager.Notification.Name.bookmarkedArticlesListUpdated,
      object: nil)
  }
  
  // MARK: - TableView Methods
  // =========================
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
    -> Int {
      print("number of bookmarked articles \(viewModel.bookmarkedArticlesCount)")
      return viewModel.bookmarkedArticlesCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! ArticleTableViewCell
      
      // Configure the cell with the data
      if let article = viewModel.articleForRow(indexPath.row) {
        cell.setCell(article)
      }
      
      // Return the cell
      return cell
  }
  
  // MARK: - Conform to Protocol
  //=============================
  func didFetchBookmarkedArticles() {
    tableView.reloadData()
  }
  
  // MARK: - Notification Handler
  //=============================
  @objc private func refreshData() {
//    viewModel.refreshData()
  }
}
