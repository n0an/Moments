//
//  MediaTableViewCell.swift
//  SYA2_Moments
//
//  Created by nag on 17/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import SAMCache

protocol MediaTableViewCellDelegate: class {
    func composeCommentButtonDidTapOnMedia(media: Media)
}

class MediaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var numberOfLikesButton: UIButton!
    @IBOutlet weak var viewAllCommentsButton: UIButton!
    
    var currentUser: User!
    
    var media: Media! {
        didSet {
            
            if currentUser != nil {
                self.updateUI()
            }
        }
    }
    
    var cache = SAMCache.shared()
    
    weak var delegate: MediaTableViewCellDelegate?
    
    func updateUI() {
        
        self.mediaImageView.image = nil
        
        let mediaImageKey = "\(media.uid)-mediaImage"

        if let image = cache?.object(forKey: mediaImageKey) as? UIImage {
            self.mediaImageView.image = image
        } else {
            
            media.downloadMediaImage { [weak self] (image, error) in
                if let image = image {
                    self?.mediaImageView.image = image
                    
                    // caching image
                    self?.cache?.setObject(image, forKey: mediaImageKey)
                    
                } else if error != nil {
                    
                    print("Error occured: \(error?.localizedDescription)")
                }
                
            }
        }
        
        
        captionLabel.text = media.caption
        likeButton.setImage(UIImage(named: "icon-like"), for: [])
        
        if media.likes.count == 0 {
            numberOfLikesButton.setTitle("Be the first to like this!", for: [])
        } else {
            numberOfLikesButton.setTitle("❤️ \(media.likes.count) likes", for: [])
            
            if media.likes.contains(currentUser) {
                likeButton.setImage(UIImage(named: "icon-like-filled"), for: [])
            }
        }
        
        if media.comments.count == 0 {
            viewAllCommentsButton.setTitle("Be the first to share a comment", for: [])
        } else {
            
            viewAllCommentsButton.setTitle("View all \(media.comments.count) comments", for: [])
            
        }
        
        
        
        
    }
    
    
    @IBAction func likeDidTap() {
        
        if media.likes.contains(currentUser) {
            likeButton.setImage(UIImage(named: "icon-like"), for: [])
            media.unlikeBy(user: currentUser)
        } else {
            likeButton.setImage(UIImage(named: "icon-like-filled"), for: [])
            media.likedBy(user: currentUser)
            
        }
        
        
    }
    
    @IBAction func commentDidTap() {
        
        self.delegate?.composeCommentButtonDidTapOnMedia(media: self.media)
        
    }
    
    @IBAction func shareDidTap() {
        
    }
    
    @IBAction func numberOfLikesDidTap() {
        
    }
    
    @IBAction func viewAllCommentsDidTap() {
        
    }
    
    
    
}


















