//
//  Article.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

struct Article: Codable {
  
  var articleId = ""
  var title = ""
  var published = Date()
  var sectionName = ""
  var fields = ""
  var thumbnail = ""
  
  enum CodingKeys: String, CodingKey {
    case articleId = "id"
    case title = "webTitle"
    case published = "webPublicationDate"
    case sectionName = "sectionName"
    case fields = "fields"
  }
  
  enum FieldCodingKey: String, CodingKey {
    case thumbnail = "thumbnail"
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
    
    // Parse thumbnail
    let fieldsContainer = try container.nestedContainer(keyedBy: FieldCodingKey.self, forKey: .fields)
    self.thumbnail = try fieldsContainer.decode(String.self, forKey: .thumbnail)
  }
  
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(title, forKey: .title)
    try container.encode(sectionName, forKey: .sectionName)
    try container.encode(published, forKey: .published)
    try container.encode(articleId, forKey: .articleId)
    
    var fieldsContainer =  container.nestedContainer(keyedBy: FieldCodingKey.self, forKey: .fields)
    
    try fieldsContainer.encode(self.thumbnail, forKey: .thumbnail)
  }
  
  init() {
    // Empty init
  }
  
}

