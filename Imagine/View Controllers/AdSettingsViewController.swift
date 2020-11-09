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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
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
  
  // MARK: A C T I O N S
  // ===================
  @IBAction func adServiceStatusSwitchTapped() {
    startLoader()
    viewModel.setAdServiceStatus(active: showAdsSwitch.isOn) { [weak self] success in
      guard let self = self else { return }
      self.stopLoader()
      self.showAdsSwitch.isOn = self.viewModel.adServiceActive
    }
  }
  
  // MARK: - UITextFieldDelegate
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    // Restrict to maximum number
    let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string) as String
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
    numberOfAdsPerDayTextField.addTarget(self, action: #selector(didFinishEditingUserDailyCAP), for: .editingChanged)
  }
  
  private func configureViewController() {
    configureNumberOfAdsDailyTextField()
    refreshAdServiceStatusSwitch()
    refreshNumberOfAdsPerDayTextField()
  }
}
