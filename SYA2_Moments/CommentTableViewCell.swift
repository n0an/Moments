//
//  CommentTableViewCell.swift
//  SYA2_Moments
//
//  Created by nag on 17/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import SAMCache

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    var comment: Comment! {
        didSet {
            self.updateUI()
        }
    }

    var cache = SAMCache.shared()
    
    func updateUI() {
        
        profileImageView.image = UIImage(named: "icon-default")
        
        
        let headerImageKey = "\(comment.from.uid)-headerImage"

        if let image = cache?.object(forKey: headerImageKey) as? UIImage {
            
            self.profileImageView.image = image
            
        } else {
            
            comment.from.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.profileImageView.image = image
                    
                    // caching profile image
                    self?.cache?.setObject(image, forKey: headerImageKey)
                    
                } else if error != nil {
                    print("Error occured: \(error?.localizedDescription)")
                }
            }
        }

      
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.masksToBounds = true
        
        commentTextLabel.text = self.comment.caption
        usernameButton.setTitle(self.comment.from.username, for: [])
        
        
    }
    
    
}
