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
   
    // Fetch the bookmarked articles
    viewModel.getBookmarkedArticles()
    // Observe the notification
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshData),
      name: DataManager.Notification.Name.bookmarkedArticlesListUpdated,
      object: nil)
  }
  
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
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController else {
      return
    }
    guard let selectedArticle = viewModel.articleForIndex(indexPath.item) else {
      return
    }
    vc.initWithArticle(selectedArticle)
    self.navigationController?.pushViewController(vc, animated: true)
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
    let padding: CGFloat = 10
    let collectionViewSize = collectionView.frame.size.width - padding
    
    return CGSize(width: collectionViewSize/2, height: 365)

  }
}



