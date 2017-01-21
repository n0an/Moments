//
//  Media.swift
//  SYA2_Moments
//
//  Created by nag on 11/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class Media {
    
    // MARK: - PROPERTIES
    var uid: String
    let type: String // "image" or "video"
    var caption: String
    var createdTime: Double!
    var createdBy: User
    var likes: [User]
    var comments: [Comment]
    var mediaImage: UIImage!
    
    // MARK: - INITIALIZERS
    init(type: String, caption: String, createdBy: User, image: UIImage) {
        self.type = type
        self.createdBy = createdBy
        self.mediaImage = image
        self.caption = caption
        
//        createdTime = Date().timeIntervalSince1970 // number of seconds from 1970
        
        comments = []
        likes = []
        uid = DatabaseReference.media.reference().childByAutoId().key
        
        
    }
    
    init(dictionary: [String: Any]) {
        
        uid = dictionary["uid"] as! String
        type = dictionary["type"] as! String
        
        let createdByDict = dictionary["createdBy"] as! [String: Any]
        createdBy = User(dictionary: createdByDict)
        
        caption = dictionary["caption"] as! String
        
        createdTime = dictionary["createdTime"] as! Double
        
        // getting liked Users
        self.likes = []
        
        if let likedUsers = dictionary["likes"] as? [String: Any] {
            
            for (_, userDict) in likedUsers {
                if let userDict = userDict as? [String: Any] {
                    self.likes.append(User(dictionary: userDict))
                }
            }
        }
        
        self.comments = []
        
        if let comments = dictionary["comments"] as? [String: Any] {
            
            for comment in comments {
                if let commentDict = comment.value as? [String: Any] {
                    self.comments.append(Comment(dictionary: commentDict))
                }
            }
        }
    }
    
    
    // MARK: - SAVE METHODS
    func save(completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.media.reference().child(uid)
        ref.setValue(toDictionary())
        
        // Save Likes
        
        for likeUser in likes {
            ref.child("likes/\(likeUser.uid)").setValue(likeUser.toDictionary())
        }
        
        // Save Comments
        
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        
        
        // Upload image to storage
        
        let firImage = FIRImage(image: mediaImage)
        
        firImage.save(self.uid, completion: { (error) in
            
            completion(error)
        })
        
        
    }
    
    func toDictionary() -> [String: Any] {
        
        return [
            
            "uid":          uid,
            "type":         type,
//            "createdTime":  createdTime,
            "createdTime": FIRServerValue.timestamp(),

            "createdBy":    createdBy.toDictionary(),
            "caption":      caption
            
        ]
        
        
    }
    
    
    
}

// MARK: - DOWNLOAD METHODS
extension Media {
    
    func downloadMediaImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadImage(uid, completion: {
            (image, error) in
            
            completion(image,error)
        })
        
    }
    
    class func observeNewMedia(_ completion: @escaping (Media) -> Void) {
        DatabaseReference.media.reference().observe(.childAdded, with: { snapshot in
            
            let media = Media(dictionary: snapshot.value as! [String: Any])
            
            completion(media)
            
        })
    }
    
    
    func observeNewComment(_ completion: @escaping (Comment) -> Void) {
        
        DatabaseReference.media.reference().child("\(uid)/comments").observe(.childAdded, with: { snapshot in
        
            let comment = Comment(dictionary: snapshot.value as! [String: Any])
            
            completion(comment)
        
        })
    }
    
    
    // MARK: - LIKES METHODS
    func likedBy(user: User) {
        self.likes.append(user)
        let ref = DatabaseReference.media.reference().child("\(uid)/likes/\(user.uid)")
        
        ref.setValue(user.toDictionary())
        
    }
    
    func unlikeBy(user: User) {
        if let index = likes.index(of: user) {
            likes.remove(at: index)
            
            let ref = DatabaseReference.media.reference().child("\(uid)/likes/\(user.uid)")
            
            ref.setValue(nil) // deleting liked user from likes
        }
    }
    
}


// MARK: - Equatable
// COMPARE METHOD (FOR "CONTAINS" FEATURE) - for checking if array constains current User
extension Media: Equatable { }

func ==(lhs: Media, rhs: Media) -> Bool {
    return lhs.uid == rhs.uid
}





















