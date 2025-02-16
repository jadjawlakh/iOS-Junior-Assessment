//
//  AdSettingsViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/4/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit
import MobAdSDK

class AdSettingsViewController: UIViewController, UITextFieldDelegate {
  @IBOutlet weak var numberOfAdsPerDayTextField: UITextField!
  @IBOutlet weak var showAdsSwitch: UISwitch!
  let viewModel = AdSettingsViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    numberOfAdsPerDayTextField.delegate = self
    configureViewController()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    displayLocationAuthorizationRequestIfNeeded()
  }
  
  @objc func didFinishEditingUserDailyCAP() {
    numberOfAdsPerDayTextField.resignFirstResponder()
    saveNumberOfAdsPerDay()
  }
  
  // MARK: - A C T I O N S
  // =====================
  @IBAction func adServiceStatusSwitchTapped() {
    startLoader()
    viewModel.setAdServiceStatus(active: showAdsSwitch.isOn) { [weak self] success in
      // TODO: Handle Error Case
      guard let self = self else { return }
      self.stopLoader()
      self.showAdsSwitch.isOn = self.viewModel.adServiceActive
    }
  }
  
  // MARK: - UITextFieldDelegate
  // ===========================
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let textField = textField.text else {
      return false
    }
    // Restrict to maximum number
    let newText = (textField as NSString).replacingCharacters(in: range, with: string) as String
    if let num = Int(newText), num >= 0 && num <= 50 {
      // Restrict input to numbers only
      let allowedCharacters = "1234567890"
      let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
      let typedCharacterSet = CharacterSet(charactersIn: string)
      return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    } else {
      return false
    }
  }
  
  // MARK: - Configure View Controller
  // =================================
  private func refreshAdServiceStatusSwitch() {
    showAdsSwitch.isOn = viewModel.adServiceActive
  }
  
  private func refreshNumberOfAdsPerDayTextField() {
    numberOfAdsPerDayTextField.text = "\(viewModel.maximumAdsPerDay)"
  }
  
  private func displayLocationAuthorizationRequestIfNeeded() {
    guard viewModel.shouldDisplayLocationPermission else {
      return
    }
    MobAdSDK.shared.requestAlwaysAuthorizationForLocationMonitoring()
    MobAdSDK.shared.activate(for: [.call, .locationChange])
  }
  
  private func saveNumberOfAdsPerDay() {
    // TODO: Handle Error Case 
    guard let stringValue = numberOfAdsPerDayTextField.text,
          let intValue = Int(stringValue) else {
      return
    }
    startLoader()
    viewModel.setMaximumAdsPerDay(cap: intValue) { success, maxAdsPerDay in
      if let maxAdsPerDay = maxAdsPerDay {
        self.numberOfAdsPerDayTextField.text = "\(maxAdsPerDay)"
      }
      self.stopLoader()
    }
  }
  
  private func configureNumberOfAdsDailyTextField() {
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45) )
    toolbar.barStyle = UIBarStyle.default
    toolbar.items = [
      UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
      UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didFinishEditingUserDailyCAP))
    ]
    numberOfAdsPerDayTextField.inputAccessoryView = toolbar
//    numberOfAdsPerDayTextField.keyboardType = .numberPad
  }
  
  private func configureViewController() {
    configureNumberOfAdsDailyTextField()
    refreshAdServiceStatusSwitch()
    refreshNumberOfAdsPerDayTextField()
  }
  
  // MARK: - H E L P E R S
  // =====================
  func customizeAlert() {
    let alertController = UIAlertController(title: "Error", message: "Oops! Something went wrong... Please try again later.", preferredStyle: .alert)
    let action = UIAlertAction(title: "Dismiss", style: .default)
    alertController.addAction(action)
    self.present(alertController, animated: true, completion: nil)
  }
  
}
