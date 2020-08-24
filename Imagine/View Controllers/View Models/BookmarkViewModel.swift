//
//  BookmarkViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/19/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

class BookmarkViewModel {
    var articles: [Article]
    init() {
        articles = [Article]()
    }
    func fetchBookmarkedArticles() {
        for article in articles {
            if article.isBookmarked == true {
                print(article.title)
            }
        }
    }
}
