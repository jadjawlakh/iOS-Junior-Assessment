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
    
    private var bookmarkedArticles = [String]()
    private var isArticleBookmarkedFlag: Bool?
    
    private init() {
        // Forbid instantiation of DataManager, the former can only be used through the shared instance
        guardianAPI = TheGuardianAPI()
        // Listen to whether the current article was bookmarked
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("BookmarkButtonPressed"), object: nil)
    }
    func getArticles(searching: Bool, completionBlock: @escaping (_ articles: [Article]?) -> Void) {
        /*
         If articles are already fetched and referenced through the 'articles' variable
         no need to do the API call.
         */
        guard articles == nil || searching == true else {
            completionBlock(articles)
            return
        }
        guardianAPI.getArticles { returnedArticles in
            self.articles = returnedArticles
            completionBlock(returnedArticles)
        }
    }
    @objc func notificationReceived(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let isArticleBookmarked = dict["isArticleBookmarked"] as? Bool {
                // do something with your bool
                isArticleBookmarkedFlag = isArticleBookmarked
            }            
        }
    }
}
