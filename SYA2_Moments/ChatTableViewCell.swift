//
//  ChatTableViewCell.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 18/01/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import SAMCache

class ChatTableViewCell: UITableViewCell {
    
    // MARK: - OUTLETS
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    
    // MARK: - PROPERTIES
    var chat: Chat! {
        didSet {
            self.updateUI()
        }
    }
    
    var cache = SAMCache.shared()
    
    // MARK: - HELPER METHODS
    func updateUI() {
        
        self.titleLabel.text = chat.title
        self.lastMessage.text = chat.lastMessage
        
        
        // Set featuredImage with caching
        
        self.featuredImageView.image = UIImage(named: "icon-defaultAvatar")
        
        let featuredImageCacheKey = chat.featuredImageUID
        
        if let cachedImage = cache?.object(forKey: featuredImageCacheKey) as? UIImage {
            self.featuredImageView.image = cachedImage
        } else {
            
            self.chat.downloadFeaturedImage { [weak self] (image, error) in
                
                self?.featuredImageView.image = image
                
                self?.cache?.setObject(image, forKey: featuredImageCacheKey)
             
            }
        
        }
        
        self.featuredImageView.layer.cornerRadius = self.featuredImageView.bounds.width / 2.0
        self.featuredImageView.layer.masksToBounds = true
        
    }
    
    
    
    
}





























