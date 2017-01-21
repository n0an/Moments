//
//  CommentComposerViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 17/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class CommentComposerViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postBarButtonItem: UIBarButtonItem!

    var currentUser: User!
    var media: Media!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = postBarButtonItem
        navigationItem.title = "Share new comment"
        
        postBarButtonItem.isEnabled = false
        captionTextView.text = ""
        captionTextView.becomeFirstResponder()
        
        captionTextView.delegate = self
        
        if currentUser.profileImage == nil {
            profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
            
            currentUser.downloadProfilePicture(completion: { [weak self] (image, error) in
                
                if let image = image {
                    self?.profileImageView.image = image
                    
                } else if error != nil {
                    print("Error occured: \(error?.localizedDescription)")
                }
            })
            
        } else {
            profileImageView.image = currentUser.profileImage
        }
        
        usernameButton.setTitle(currentUser.username, for: [])
    }
    
    
    deinit {
        print("CommentComposerViewController deinit")
    }
    
    @IBAction func postDidTap() {
        
        let comment = Comment(mediaUID: media.uid, from: currentUser, caption: captionTextView.text)
        comment.save()
        
        media.comments.append(comment)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    

}



extension CommentComposerViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text == "" {
            postBarButtonItem.isEnabled = false
        } else {
            postBarButtonItem.isEnabled = true
        }
        
    }
    
    
}
















