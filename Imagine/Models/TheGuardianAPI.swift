//
//  TheGuardianAPI.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

class TheGuardianAPI {
    func getArticles(completionBlock: @escaping (_ articles: [Article]?) -> Void) {
        // Create a URL object and make sure it exists
        guard let url = URL(string: Constants.API_URL) else {
            completionBlock(nil)
            return
        }
        // Get a URLSession object
        let session = URLSession.shared
        // Get a data task from the URLSession object
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completionBlock(nil)
                return
            }
            do {
                // Parasing the data into article objects
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(Response.self, from: data)
                if let results = response.results {
                    DispatchQueue.main.async {
                        completionBlock(results)
                    }
                } else {
                    completionBlock(nil)
                }
                dump(response)
            } catch {
                completionBlock(nil)
                print("Error: failed to get response")
            }
        }
        // Kick off the task
        dataTask.resume()
    }
}
