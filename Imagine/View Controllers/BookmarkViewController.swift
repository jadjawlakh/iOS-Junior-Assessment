//
//  BookmarkViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/19/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class BookmarkViewController: UIViewController, BookmarkViewModelDelegate {
  let viewModel = BookmarkViewModel()
  
  //  @IBOutlet weak var bookmarkTableView: UITableView!
  
  @IBOutlet weak var bookmarkCollectionView: UICollectionView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Link the BookmarkViewController to the BookmarkViewModel
    viewModel.delegate = self
    bookmarkCollectionView.delegate = self
    bookmarkCollectionView.dataSource = self
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 120, height: 120)
    bookmarkCollectionView.collectionViewLayout = layout
   
    
    
    // Set itself as the data source and the delegate
    //    bookmarkTableView.dataSource = self
    //    bookmarkTableView.delegate = self
    // Fetch the bookmarked articles
    viewModel.getBookmarkedArticles()
    // Observe the notification
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshData),
      name: DataManager.Notification.Name.bookmarkedArticlesListUpdated,
      object: nil)
  }
  
  //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  //    // Confirm that an article was selected
  //    guard bookmarkTableView.indexPathForSelectedRow != nil else {
  //      return
  //    }
  //    // Get a reference to the article that was tapped on
  //    let selectedArticle = viewModel.bookmarkedArticles[bookmarkTableView.indexPathForSelectedRow!.row]
  //    // Get a reference to the detailViewController
  //    let detailVC = segue.destination as! DetailViewController
  //    // Set the article property of the detailViewController
  //    detailVC.initWithArticle(selectedArticle)
  //  }
  
  // MARK: - TableView Methods
  // =========================
  //  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
  //    -> Int {
  //      return viewModel.bookmarkedArticlesCount
  //  }
  //
  //  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
  //    -> UITableViewCell {
  //      let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkCell", for: indexPath) as! ArticleTableViewCell
  //
  //      // Configure the cell with the data
  //      if let article = viewModel.articleForRow(indexPath.row) {
  //        cell.setCell(article)
  //      }
  //
  //      // Return the cell
  //      return cell
  //  }
  
  // MARK: - Conform to Protocol
  //=============================
  func didFetchBookmarkedArticles() {
    bookmarkCollectionView.reloadData()
  }
  
  // MARK: - Notification Handler
  //=============================
  @objc private func refreshData() {
    viewModel.refreshData()
  }
}

extension BookmarkViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    print("you tapped me")
  }
}

extension BookmarkViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.bookmarkedArticlesCount
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCollectionViewCell", for: indexPath) as! BookmarkCollectionViewCell
    
    let article = viewModel.bookmarkedArticles[indexPath.row]
    cell.setCell(article)
    

  

   

    return cell
  }
}

extension BookmarkViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 425, height: 500)
  }
}



