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
    
    //    var article: Article?
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
    }
    
    
}
