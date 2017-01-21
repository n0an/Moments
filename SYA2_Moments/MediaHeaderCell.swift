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

        
        if let image = cache?.object(forKey: headerImageKey) as? UIImage {

            self.profileImageView.image = image
            
        } else {
            
            media.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.profileImageView.image = image
                    
                    // caching profile image
                    self?.cache?.setObject(image, forKey: headerImageKey)
                    
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
            print("===NAG===: followButton.isHidden = true")
            followButton.isHidden = true
        } else {
            print("===NAG===: followButton.isHidden = false")
            followButton.isHidden = false
        }
    }
    
    
    
    @IBAction func followDidTap() {
    
        currentUser.follow(user: media.createdBy)
        media.createdBy.isFollowedBy(user: currentUser)
        
        self.updateUI()

    
    }

    

}











