//
//  MainViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MainViewModelDelegate {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UITextField!
  
  var viewModel = MainViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Upon tapping the 'return' button from the searchbar input field
    searchBar.addTarget(self, action: #selector(returnButtonTapped), for: .editingDidEndOnExit)
    // Link the MainViewController to the MainViewModel
    viewModel.delegate = self
    // Set itself as the data source and the delegate
    tableView.dataSource = self
    tableView.delegate = self
    // Fetch the articles
    viewModel.getArticles(searching: false)
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshData),
      name: DataManager.Notification.Name.articlesListUpdated,
      object: nil)
  }
  
  @objc func returnButtonTapped() {
    Constants.SEARCH_QUERY = searchBar.text!
    viewModel.getArticles(searching: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Confirm that an article was selected
    guard tableView.indexPathForSelectedRow != nil else {
      return
    }
    // Get a reference to the article that was tapped on
    let selectedArticle = viewModel.articles[tableView.indexPathForSelectedRow!.row]
    // Get a reference to the detailViewController
    let detailVC = segue.destination as! DetailViewController
    // Set the article property of the detailViewController
    detailVC.initWithArticle(selectedArticle)
  }
  
  // MARK: - TableView Methods
  //==========================
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.articles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ARTICLECELL_ID, for: indexPath) as! ArticleTableViewCell
    // Configure the cell with the data
    let article = viewModel.articles[indexPath.row]
    cell.setCell(article)
    // Return the cell
    return cell
  }
  
  // MARK: - Conform to protocol ArticleModelDelegate
  //=================================================
  func didFetchArticles() {
    tableView.reloadData()
  }
  
  // MARK: - Notification Handler
  //=============================
  @objc private func refreshData() {
    viewModel.refreshData()
  }
}
