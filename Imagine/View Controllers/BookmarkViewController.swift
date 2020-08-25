//
//  BookmarkViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/19/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class BookmarkViewController: UITableViewController {
    let viewModel = BookmarkViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
      
      NotificationCenter.default.addObserver(
           self,
           selector: #selector(refreshData),
           name: DataManager.Notification.Name.bookmarkedArticlesListUpdated,
           object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Listen to whether the current article was bookmarked
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("BookmarkButtonPressed"), object: nil)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookmark_cell", for: indexPath)
        
        // Configure the cell with the data
        let article = viewModel.articles[indexPath.row]

      // Return the cell
        return cell
    }
    
    @objc func notificationReceived(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let isArticleBookmarked = dict["isArticleBookmarked"] as? Bool {
                // do something with your bool
                print(isArticleBookmarked)
            }
        }
    }
  
  // MARK: - Notification Handler
  //=============================
  @objc private func refreshData() {
    viewModel.refreshData()
  }
}
