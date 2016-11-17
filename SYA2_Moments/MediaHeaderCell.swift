//
//  MediaHeaderCell.swift
//  SYA2_Moments
//
//  Created by nag on 17/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import SAMCache

class MediaHeaderCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    
    var currentUser: User!
    
    var media: Media! {
        didSet {
            if currentUser != nil {
                self.updateUI()
            }
        }
    }
    
    var cache = SAMCache.shared()
    
    func updateUI() {
        
        profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        let headerImageKey = "\(media.createdBy.uid)-headerImage"

        
//        if let image = cache?.object(forKey: "\(self.media.createdBy.uid)-headerImage") as? UIImage {
        
        if let image = cache?.object(forKey: headerImageKey) as? UIImage {

            self.profileImageView.image = image
            
        } else {
            
            media.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.profileImageView.image = image
                    
                    // caching profile image
                    // TODO: comment about need add ! unwrap
//                    self?.cache?.setObject(image, forKey: "\((self?.media.createdBy.uid)!)-headerImage")
                    self?.cache?.setImage(image, forKey: headerImageKey)
                    
                } else if error != nil {
                    print("Error occured: \(error?.localizedDescription)")
                }
            }
        }
        
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width/2
        profileImageView.clipsToBounds = true
        
        usernameButton.setTitle(media.createdBy.username, for: [])
        
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        
        followButton.layer.masksToBounds = true
        
        if currentUser.follows.contains(media.createdBy) || media.createdBy.uid == currentUser.uid {
            followButton.isHidden = true
        } else {
            followButton.isHidden = false
        }
    }

    

}











