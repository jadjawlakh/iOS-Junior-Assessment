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
  @IBOutlet weak var showAdsSwitch: UISwitch!
  
  
  @IBAction func unwindHome(_ segue: UIStoryboardSegue) {
    // this is intentionally blank
  }
  
  var viewModel = MainViewModel()
  
  var refreshControl: UIRefreshControl?
  
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
    viewModel.getArticles()
    // Observe the notification
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(refreshDataList),
      name: DataManager.Notification.Name.bookmarkedArticlesListUpdated,
      object: nil)
    addRefreshControl()
  }
  
  // START: HANDLE REFRESH CONTROL
  // =============================
  
  func addRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl?.tintColor = UIColor.gray
    refreshControl?.addTarget(self, action: #selector(refreshList), for: .valueChanged)
    tableView.addSubview(refreshControl!)
  }
  
  @objc func refreshList() {
    viewModel.articles.removeAll()
    viewModel.getArticles(query: searchBar.text ?? "", page: 1)
    refreshControl?.endRefreshing()
    tableView.reloadData()
  }
  
  // END: HANDLE REFRESH CONTROL
  // ===========================
  
  // START: HANDLE PAGINATION
  // ========================
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = scrollView.contentOffset.y
    let contentHeight = scrollView.contentSize.height
    
    self.tableView.tableFooterView = createSpinnerFooter()
    
    if offsetY > contentHeight - scrollView.frame.height {
      if !viewModel.isFetching {
        self.tableView.tableFooterView = nil
        beginBatchFetch()
      }
    }
  }
  
  func beginBatchFetch() {
    viewModel.fetchNextBatch()
  }
  
  func createSpinnerFooter() -> UIView {
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
    let spinner = UIActivityIndicatorView()
    spinner.center = footerView.center
    footerView.addSubview(spinner)
    spinner.startAnimating()
    return footerView
  }
  
  // END: HANDLE PAGINATION
  // ======================
  @objc func returnButtonTapped() {
    viewModel.getArticles(query: searchBar.text ?? "", page: 1)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? DetailViewController {
      // Confirm that an article was selected
      guard let index = tableView.indexPathForSelectedRow else {
        return
      }
      // Get a reference to the article that was tapped on
      let selectedArticle = viewModel.articles[index.row]
      // Set the article property of the detailViewController
      detailVC.initWithArticle(selectedArticle)
    } else if let navigationVC = segue.destination as? UINavigationController {
      if let settingsVC = navigationVC.visibleViewController as? SettingsViewController {
        // If there's need to send info to settings VC add them after this line
      }
    }
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
  @objc private func refreshDataList() {
    viewModel.refreshData()
  }
  
  // MARK: - Handle Ad Service Switch
  // ================================
  @IBAction func adServiceStatusSwitchTapped() {
    viewModel.setAdServiceStatus(active: showAdsSwitch.isOn) { [weak self] success in
      guard let self = self else { return }
      self.showAdsSwitch.isOn = self.viewModel.adServiceActive
    }
  }
  
  private func refreshAdServiceStatusSwitch() {
    showAdsSwitch.isOn = viewModel.adServiceActive
  }
}
