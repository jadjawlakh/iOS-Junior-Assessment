//
//  BookmarkButton.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/14/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class BookmarkButton: UIButton {
  static let blue = UIColor(red: 46.0/255.0, green: 123.0/255.0, blue: 255.0/255.0, alpha: 1.0)
  
  var isBookmarked: Bool = false {
    didSet {
      refreshUserInterface()
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initButton()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initButton()
  }
  
  func initButton() {
    layer.borderWidth = 2.0
    layer.borderColor = BookmarkButton.blue.cgColor
    layer.cornerRadius = frame.size.height/2
    setTitleColor(BookmarkButton.blue, for: .normal)
    refreshUserInterface()
  }
  
  func refreshUserInterface() {
    if isBookmarked {
      setTitle("Remove From Bookmarks", for: .normal)
    } else {
      setTitle("Add To Bookmarks", for: .normal)
    }
  }
}
