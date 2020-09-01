//
//  Constants.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

struct Constants {
    static var API_KEY = "a4493376-c0c3-475b-8651-f9c00beccab7"
    static var SEARCH_QUERY = ""
    static var ARTICLECELL_ID = "ArticleCell"
    static var TG_EMBED_URL = "https://theguardian.com/"
    // Computed variable
    static var API_URL: String {
      return "https://content.guardianapis.com/search?q=\(Constants.SEARCH_QUERY)&api-key=\(Constants.API_KEY)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
