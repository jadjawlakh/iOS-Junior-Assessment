//
//  TheGuardianAPI.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

protocol TheGuardianAPIDelegate: class {
    func articlesFetched(_ articles: [Article])
}

class TheGuardianAPI {
    weak var delegate: TheGuardianAPIDelegate?
    
    func getArticles() {
        // Create a URL object and make sure it exists
        guard let url = URL(string: Constants.API_URL) else {
            return
        }
        // Get a URLSession object
        let session = URLSession.shared
        // Get a data task from the URLSession object
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                return
            }
            do {
                // Parasing the data into article objects
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let response = try decoder.decode(Response.self, from: data)
                if response.results != nil {
                    DispatchQueue.main.async {
                        // Call the "articlesFetched" methods of the delegate
                        self.delegate?.articlesFetched(response.results!)
                    }
                }
                dump(response)
            } catch {
                print("Error: failed to get response")
            }
        }
        // Kick off the task
        dataTask.resume()
    }
}
