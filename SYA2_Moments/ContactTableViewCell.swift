//
//  ContactTableViewCell.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 18/01/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import SAMCache


class ContactTableViewCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var emailTextLabel: UILabel!

    // MARK: - PROPERTIES
    var user: User! {
        didSet {
            self.updateUI()
        }
    }
    
    var cache = SAMCache.shared()
    
    var added: Bool = false {
        didSet {
            if added == false {
                self.checkBoxImageView.image = UIImage(named: "icon-checkbox")
            } else {
                self.checkBoxImageView.image = UIImage(named: "icon-checkbox-filled")
            }
        }
    }
    
    // MARK: - HELPER METHODS
    func updateUI() {
        
        self.checkBoxImageView.image = UIImage(named: "icon-checkbox")
        
        self.displayNameLabel.text = user.username
        self.emailTextLabel.text = user.fullName
        
        
        // Set featuredImage with caching
        
        self.profileImageView.image = UIImage(named: "icon-defaultAvatar")
        
        let profileImageCacheKey = "\(user.uid)-profileImage"
        
        if let cachedImage = cache?.object(forKey: profileImageCacheKey) as? UIImage {
            self.profileImageView.image = cachedImage
        } else {
            
            user.downloadProfilePicture { [weak self] (image, error) in
                
                self?.profileImageView.image = image
                
                self?.cache?.setObject(image, forKey: profileImageCacheKey)
                
            }
            
        }

        self.profileImageView.layer.cornerRadius = self.profileImageView.bounds.width / 2.0
        self.profileImageView.layer.masksToBounds = true

        

    }
    
    
    
}























