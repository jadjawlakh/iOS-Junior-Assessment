//
//  TheGuardianAPI.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

enum TheGuardianAPI {
  case searchArticles(query: String, page: Int)
  
  var path: String {
    switch self {
    case .searchArticles:
      return "/search"
    }
  }
  
  var url: URL? {
    guard let baseURL = URL(string: TheGuardianAPI.BASE_URL),
      var baseURLComponent = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
      return nil
    }
    
    baseURLComponent.path = self.path

    switch self {
    case .searchArticles(let query, let page):
      baseURLComponent.queryItems = [
        URLQueryItem(name: "q", value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
        URLQueryItem(name: "page", value: "\(page)"),
        URLQueryItem(name: "show-fields", value: "thumbnail")
      ]
    }
    
    var queryItems = baseURLComponent.queryItems ?? []
    queryItems.append(URLQueryItem(name: "api-key", value: TheGuardianAPI.API_KEY))
    baseURLComponent.queryItems = queryItems
    
    return baseURLComponent.url
  }
}

extension TheGuardianAPI {
  private static let API_KEY = "a4493376-c0c3-475b-8651-f9c00beccab7"
  private static let BASE_URL = "https://content.guardianapis.com"
}

extension TheGuardianAPI {
  static func getArticles(query: String, page: Int, completionBlock: @escaping (_ articles: [Article]?) -> Void) {
    let api = TheGuardianAPI.searchArticles(query: query, page: page)
    
    // Create a URL object and make sure it exists
    guard let url = api.url else {
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
