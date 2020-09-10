//
//  CacheManager.swift
//  Imagine
//
//  Created by Jad Jawlakh on 9/10/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import Foundation

class CacheManager {
  
  static var cache = [String: Data]()
  
  static func setThumbnailCache(_ url: String, _ data: Data?) {
    // Store the image data and use the url as the key
    cache[url] = data
  }
  
  static func getThumbnailCache(_ url: String) -> Data? {
    // Try to get the data for the specified url
    return cache[url]
  }
  
}
