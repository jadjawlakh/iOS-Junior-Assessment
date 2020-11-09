//
//  UIViewController+Extension.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/9/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
  func startLoader() {
    startAnimating(type: NVActivityIndicatorType.pacman, color: UIColor.white)
  }
  
  func stopLoader() {
    stopAnimating()
  }
}
