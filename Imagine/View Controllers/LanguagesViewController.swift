//
//  LanguagesTableViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/5/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class LanguagesViewController: UITableViewController {
  let viewModel = LanguagesViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    customizeViewController()

    viewModel.loadLanguages { success in
      self.tableView.reloadData()
      if !success {
        // Display an error message
      }
    }
  }
  
  // MARK: - Table View Functionalities
  // ==================================
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows(in: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let success = viewModel.selectLanguage(at: indexPath)
    cell.isSelectedStyle = success
  }
  
  override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
    guard viewModel.canDeselectLanguage(at: indexPath) else {
      return nil
    }
    return indexPath
  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let success = viewModel.deselectLanguage(at: indexPath)
    cell.isSelectedStyle = !success
  }
  
  // MARK: - A C T I O N S
  // =====================
  @objc func saveButtonTapped(_ sender: Any) {
    viewModel.save { (success) in
      guard success else {
        // TODO: Display an error message
        return
      }
    }
  }
  
  // MARK: - H E L P E R S
  // =====================
  func customizeViewController() {
    // Rmove lines of empty rows
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
