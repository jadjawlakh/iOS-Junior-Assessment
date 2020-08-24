//
//  DetailViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, DetailViewModelDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    var viewModel = DetailViewModel()
    func initWithArticle(_ article: Article) {
        viewModel.article = article
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Safe unwrapping into a new variable
        if let request = viewModel.request {
            webView.load(request)
        }
        // Set the title
        titleLabel.text = viewModel.title
        // Set the date
        dateLabel.text = viewModel.publicationDate
        // Listen to whether the current article was bookmarked
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived), name: Notification.Name("BookmarkButtonPressed"), object: nil)
    }
    @objc func notificationReceived(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        if let dict = notification.userInfo as NSDictionary? {
            if let isArticleBookmarked = dict["isArticleBookmarked"] as? Bool {
                // do something with your bool
                print(isArticleBookmarked)
            }
        }
    }
}
