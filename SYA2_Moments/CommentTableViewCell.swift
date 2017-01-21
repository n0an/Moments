//
//  CommentTableViewCell.swift
//  SYA2_Moments
//
//  Created by nag on 17/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    var comment: Comment! {
        didSet {
            self.updateUI()
        }
    }

    
    func updateUI() {
        
        profileImageView.image = UIImage(named: "icon-default")
        
        comment.from.downloadProfilePicture { [weak self] (image, error) in
            
            self?.profileImageView.image = image
            
//            if let image = image {
//                
//                self?.profileImageView.image = image
//                
//            } else {
//                print("Error occured: \(error?.localizedDescription)")
//            }
        }
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.layer.masksToBounds = true
        
        commentTextLabel.text = self.comment.caption
        usernameButton.setTitle(self.comment.from.username, for: [])
        
        
    }
    
    
}
