//
//  ArticleModel.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

protocol ArticleModelDelegate {
    func articlesFetched(_ articles: [Article])
}


class ArticleModel {
    
    var delegate: ArticleModelDelegate?
    
    
    
    func getArticles() {
        
        // Create a URL object
        let url = URL(string: Constants.API_URL)
        
        guard url != nil else {
            return
        }
        
        // Get a URLSession object
        let session = URLSession.shared
        
        // Get a data task from the URLSession object
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            // Check if there were any errors
            if error != nil || data == nil {
                return
            }
            
            do {
                // Parasing the data into article objects
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                let response = try decoder.decode(Response.self, from: data!)
                
                
                if response.results != nil {
                    
                    DispatchQueue.main.async {
                        // Call the "articlesFetched" methods of the delegate
                        self.delegate?.articlesFetched(response.results!)
                    }
                
                }
                
                
                dump(response)
                
            } catch {
                
            }
            
        }
        // Kick off the task
        dataTask.resume()
        
    }
}
