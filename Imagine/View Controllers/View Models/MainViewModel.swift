//
//  MainViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/18/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

// Protocol needs to conform by a class
protocol MainViewModelDelegate: class {
    func didFetchArticles()
}


class MainViewModel: ArticleModelDelegate {
    weak var delegate: MainViewModelDelegate?
    
    var articleModel: ArticleModel
    var articles: [Article]
    
    init() {
        articleModel = ArticleModel()
        articles = [Article]()
        articleModel.delegate = self
    }
    
    func getArticles() {
        articleModel.getArticles()
    }
    
    // MARK: - Conform to protocol ArticleModelDelegate
    func articlesFetched(_ articles: [Article]) {
        // Set the returned articles to our article property
        self.articles = articles
        
        delegate?.didFetchArticles()
    }
}
