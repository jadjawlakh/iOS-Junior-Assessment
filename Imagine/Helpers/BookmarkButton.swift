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
//    var isBookmarked = false
    var article: Article = Article()
    
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
        
        addTarget(self, action: #selector(BookmarkButton.buttonPressed), for: .touchUpInside)
    }
    
    @objc func buttonPressed() {
        
        print(article.isBookmarked)
        guard article.isBookmarked != nil else {
            return
        }
        activateButton(bool: !(article.isBookmarked))
    }
    
    func activateButton(bool: Bool) {
        article.isBookmarked = bool
        let title = bool ? "Remove from bookmarks" : "Add to bookmarks"
        setTitle(title, for: .normal)
    }
    
}
