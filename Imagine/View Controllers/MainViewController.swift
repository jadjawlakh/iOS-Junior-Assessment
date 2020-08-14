//
//  MainViewController.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ArticleModelDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var model = ArticleModel()
    var articles = [Article]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Constants.SEARCH_QUERY = searchBar.text!
        
        // Set itself as the data source and the delegate
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set itself as the delegate of the model
        model.delegate = self
        
        // Fetch the articles
        model.getArticles()
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Confirm that an article was selected
        guard tableView.indexPathForSelectedRow != nil else {
            return
        }
        
        // Get a reference to the article that was tapped on
        let selectedArticle = articles[tableView.indexPathForSelectedRow!.row]
        
        // Get a reference to the detailViewController
        let detailVC = segue.destination as! DetailViewController

        // Set the article property of the detailViewController
        detailVC.article = selectedArticle
    }
    
    // MARK: - Article Model Delegate Methods
    func articlesFetched(_ articles: [Article]) {
        // Set the returned articles to our article property
        self.articles = articles
        
        // Refresh the tableView
        tableView.reloadData()
    }
    
    // MARK: - TableView Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ARTICLECELL_ID, for: indexPath) as! ArticleTableViewCell
        
        // Configure the cell with the data
        let article = self.articles[indexPath.row]
        cell.setCell(article)
        
        // Return the cell
        return cell
    }
    
    
    
}
