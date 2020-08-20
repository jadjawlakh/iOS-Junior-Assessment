//
//  DataManager.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/20/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    var guardianAPI: TheGuardianAPI
    private var articles: [Article]?
    private init() {
        // Forbid instantiation of DataManager, the former can only be used through the shared instance
        guardianAPI = TheGuardianAPI()
    }
    func getArticles(competionBlock: @escaping (_ articles: [Article]?) -> Void) {
        /*
         If articles are already fetched and referenced through the 'articles' variable
         no need to do the API call.
         */
        guard articles == nil else {
            competionBlock(articles)
            return
        }
        guardianAPI.getArticles { returnedArticles in
            self.articles = returnedArticles
            competionBlock(returnedArticles)
        }
    }
}
