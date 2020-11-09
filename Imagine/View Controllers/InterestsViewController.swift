//
//  PreferencesTableViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/5/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class InterestsViewController: UITableViewController {
  
  let viewModel = InterestsViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    viewModel.loadInterests { success in
      defer {
        self.tableView.reloadData()
      }
      guard success else {
        // Display error if needed
        return
      }
    }
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return viewModel.numberOfSections
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRowsIn(section: section)
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    let info = viewModel.informationForCellAtIndexPath(indexPath)
    cell.textLabel?.text = info?.title
    let shouldSelect = info?.isSelected ?? false
    cell.isSelectedStyle = shouldSelect
    if shouldSelect {
      tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    } else {
      tableView.deselectRow(at: indexPath, animated: false)
    }
    return cell
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let view = TableViewSectionHeader()
    view.title = viewModel.titleForHeaderInSection(section)
    return view
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let success = viewModel.selectUserInterest(at: indexPath)
    cell.isSelectedStyle = success
  }
  
  override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) else {
      return
    }
    let success = viewModel.deselectUserInterest(at: indexPath)
    cell.isSelectedStyle = !success
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40
  }
  
  // MARK: - A C T I O N S
  // =====================
  @IBAction func actionBarButtonTapped() {
    let actionController = UIAlertController(
      title: "What to Do", message: nil, preferredStyle: .actionSheet)
    let selectAllButton = UIAlertAction(
      title: "Select All", style: .default) { _ in
      self.selectAllSubcategories()
    }
    let unselectAllButton = UIAlertAction(
      title: "Deselect All", style: .destructive) { _ in
      self.unselectAllSubcategories()
    }
    let saveButton = UIAlertAction(
      title: "Save", style: .default) { _ in
      self.saveBarButtonTapped()
    }
    let cancelBarButton = UIAlertAction(
      title: "Cancel", style: .cancel, handler: nil)
    actionController.addAction(selectAllButton)
    actionController.addAction(unselectAllButton)
    actionController.addAction(cancelBarButton)
    present(actionController, animated: true, completion: nil)
  }
  
  @IBAction func saveBarButtonTapped() {
    viewModel.saveChanges { success -> Void in
      guard success else {
        return
      }
      self.refreshVisibleRows()
    }
  }
  
  // MARK: - H E L P E R S
  // =====================
  func selectAllSubcategories() {
    viewModel.selectAllSubcategories()
    refreshVisibleRows()
  }
  
  func unselectAllSubcategories() {
    viewModel.deselectAllSubcategories()
    refreshVisibleRows()
  }
  
  func refreshVisibleRows() {
    guard let indexPathOfVisibleRows = tableView.indexPathsForVisibleRows else {
      return
    }
    tableView.reloadRows(at: indexPathOfVisibleRows, with: .none)
  }
}


