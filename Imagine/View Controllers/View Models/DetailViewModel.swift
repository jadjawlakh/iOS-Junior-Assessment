//
//  DetailViewModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/18/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

protocol DetailViewModelDelegate: class {
    func didFetchArticles()
}

class DetailViewModel: ArticleModelDelegate {
    
   
    weak var delegate: ArticleModelDelegate?
    
    var article: Article
 
    init() {
        article = Article()
    }
    
    func articlesFetched(_ articles: [Article]) {
           
       }
       
}
