//
//  MainViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/18/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

// MARK: -  MainViewModel Protocol and MainViewModel Class
// Protocol needs to conform by a class
protocol MainViewModelDelegate: class {
    func didFetchArticles()
}

class MainViewModel: TheGuardianAPIDelegate {
    weak var delegate: MainViewModelDelegate?
    var guardianAPI: TheGuardianAPI
    var articles: [Article]
    
    init() {
        guardianAPI = TheGuardianAPI()
        articles = [Article]()
        guardianAPI.delegate = self
    }
    
    func getArticles() {
        guardianAPI.getArticles()
    }
    // MARK: - Conform to protocol ArticleModelDelegate
    func articlesFetched(_ articles: [Article]) {
        // Set the returned articles to our article property
        self.articles = articles
        delegate?.didFetchArticles()
    }
}
