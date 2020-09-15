//
//  ArticleTableViewCell.swift
//  Imagine
//
//  Created by Jad Jawlakh on 8/13/20.
//  Copyright © 2020 Imagine Works. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var sectionLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
  func setCell(_ article: Article) {
    
    // Set the title
    self.titleLabel.text = "📰 \(article.title)"
    
    // Set the section
    self.sectionLabel.text = "🧭 \(article.sectionName)"
    
    // Set the date
    let df = DateFormatter()
    df.dateFormat = "EEEE, MMM d, yyyy"
    self.dateLabel.text = "📆 \(df.string(from: article.published))"
    
    // Set the thumbnail
    // Ensure that we have a thumbnail
    guard article.thumbnail != "" else {
      return
    }
    
    // Check cache before downloading data
    if let cachedData = CacheManager.getThumbnailCache(article.thumbnail) {
      // Set the thumbail imageView
      self.thumbnailImageView.image = UIImage(data: cachedData)
      return
    } else if let url = URL(string: article.thumbnail) {
      // Download the thumbnail data
      //============================
      
      // Get the shared URL Session object
      let session = URLSession.shared
      
      // Create a data task
      let dataTask = session.dataTask(with: url) { (data, response, error) in
        // if there's no error, and there's data
        guard error == nil, let data = data else {
          return
        }
        
        // Save the data in the cache
        CacheManager.setThumbnailCache(url.absoluteString, data)
        
        // Check that the downloaded url matches the video thumbnail url that this cell is currently  set to display
        if url.absoluteString != article.thumbnail {
          // Article cell has been recycled for another article and no longer matches the thumbnail that was downloaded
          return
        }
        
        // Create the image object
        let image = UIImage(data: data)
        
        // Set the imageView
        DispatchQueue.main.async {
          self.thumbnailImageView.image = image
        }
      }
      
      // Start data task
      dataTask.resume()
    }
  }
  
}
