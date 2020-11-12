//
//  LanguagesTableViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/5/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  let viewModel = LanguagesViewModel()
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    customizeViewController()
    loadData()
  }
  
  // MARK: - Table View Functionalities
  // ==================================
  func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    let info = viewModel.informationForCell(at: indexPath)
    cell.textLabel?.text = info?.title
    cell.detailTextLabel?.text = info?.subtitle
    let shouldSelect = info?.isSelected ?? false
    cell.isSelectedStyle = shouldSelect
    if shouldSelect {
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    } else {
      tableView.deselectRow(at: indexPath, animated: false)
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let success = viewModel.selectLanguage(at: indexPath)
    cell.isSelectedStyle = success
  }
  
  func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
    guard viewModel.canDeselectLanguage(at: indexPath) else {
      return nil
    }
    return indexPath
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let success = viewModel.deselectLanguage(at: indexPath)
    cell.isSelectedStyle = !success
  }
  
  // MARK: - A C T I O N S
  // =====================
  @IBAction func saveButtonTapped(_ sender: Any) {
    startLoader()
    viewModel.save { (success) in
      self.stopLoader()
      guard success else {
        self.customizeAlert()
        return
      }
    }
  }
  
  // MARK: - H E L P E R S
  // =====================
  func loadData() {
    startLoader()
    viewModel.loadLanguages { success in
      self.stopLoader()
      self.tableView.reloadData()
      guard success else {
        self.customizeAlert()
        return
      }
    }
  }
  
  func customizeAlert() {
    let alertController = UIAlertController(title: "Error", message: "Oops! Something went wrong... Please try again later.", preferredStyle: .alert)
    let action = UIAlertAction(title: "Dismiss", style: .default)
    alertController.addAction(action)
    self.present(alertController, animated: true, completion: nil)
  }
  
  func customizeViewController() {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.tableFooterView = UIView()
    // Add Save bar button
    let saveBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveButtonTapped(_:)))
    navigationItem.rightBarButtonItem = saveBarButton
  }
}

// MARK: - UITableViewCell Extension
//==================================
extension UITableViewCell {
  var isSelectedStyle: Bool {
    get {
      self.accessoryType == UITableViewCell.AccessoryType.checkmark
    }
    set {
      self.accessoryType = newValue ?
        UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
    }
  }
}
