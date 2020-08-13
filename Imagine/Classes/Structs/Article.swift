//
//  Article.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

struct Article: Decodable {
    
    var articleId = ""
    var title = ""
    var published: Date
    var sectionName = ""
    
    enum CodingKeys: String, CodingKey {
        case articleId = "id"
        case title = "webTitle"
        case published = "webPublicationDate"
        case sectionName = "sectionName"
    }
    
    
    init (from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Parse Title
        self.title = try container.decode(String.self, forKey: .title)
        
        // Parse Section Name
        self.sectionName = try container.decode(String.self, forKey: .sectionName)

        // Parse the Publish Data
        self.published = try container.decode(Date.self, forKey: .published)

         
        // Parse Article ID
        self.articleId = try container.decode(String.self, forKey: .articleId)
        
    }
    
}
