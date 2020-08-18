//
//  Response.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

struct Response: Decodable {
    
    var results: [Article]?
    
    enum CodingKeys: String, CodingKey {
        case response = "response"
        case results = "results"
    }
    
    init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let responseContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
        self.results = try responseContainer.decode([Article].self, forKey: .results)
    }
}
