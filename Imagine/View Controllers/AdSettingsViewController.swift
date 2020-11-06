//
//  AdSettingsViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/4/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class AdSettingsViewController: UIViewController {
class AdSettingsViewController: UIViewController, UITextFieldDelegate {
  
    override func viewDidLoad() {
  @IBOutlet weak var numberOfAdsPerDayTextField: UITextField!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    numberOfAdsPerDayTextField.delegate = self
    }
  
  // MARK: - UITextFieldDelegate
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    let allowedCharacters = "1234567890"
    let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
    let typedCharacterSet = CharacterSet(charactersIn: string)
    return allowedCharacterSet.isSuperset(of: typedCharacterSet)
    
  }
}
