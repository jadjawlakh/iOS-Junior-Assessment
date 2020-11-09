//
//  TableViewSectionHeader.swift
//  Imagine
//
//  Created by Jad Jawlakh on 11/9/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class TableViewSectionHeader: UIView {
  @IBOutlet var contentView: UIView!
  @IBOutlet weak var textLabel: UILabel!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
    
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }

  private func initialize() {
    Bundle.main.loadNibNamed("TableViewSectionHeader", owner: self, options: nil)
    contentView.fixInView(self)
    applyTheme()
  }
  
  
  var title: String? {
    get {
      return textLabel.text
    }
    set {
      textLabel.text = newValue
    }
  }
  
  private func applyTheme() {
    contentView.backgroundColor = UIColor.orange
  }

}

// MARK: - UIView
//===============
extension UIView
{
  func fixInView(_ container: UIView!) -> Void{
    self.translatesAutoresizingMaskIntoConstraints = false;
    self.frame = container.frame;
    container.addSubview(self);
    NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
    NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
  }
}
