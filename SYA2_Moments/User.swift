//
//  User.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 08/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    let uid: String
    var username: String
    var fullName: String
    var bio: String
    var website: String
    var profileImage: UIImage?
    
    var follows: [User]
    var followedBy: [User]
    
    // MARK: - INITIALIZERS
    init(uid: String, username: String, fullName: String, bio: String, website: String, follows: [User], followedBy: [User], profileImage: UIImage?) {
        
        self.uid = uid
        self.username = username
        self.fullName = fullName
        self.bio = bio
        self.website = website
        
        self.follows  = follows
        self.followedBy = followedBy
        
        self.profileImage = profileImage
        
    }
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as! String
        self.username = dictionary["username"] as! String
        self.fullName = dictionary["fullName"] as! String
        self.bio = dictionary["bio"] as! String
        self.website = dictionary["website"] as! String
        
        // follows
        
        self.follows = []
        
        if let followsDict = dictionary["follows"] as? [String: Any] {
            for (_, userDict) in followsDict {
                if let userDict = userDict as? [String : Any] {
                    self.follows.append(User(dictionary: userDict))
                }
            }
        }
        
        // followed by
        
        self.followedBy = []
        
        if let followedByDict = dictionary["followedBy"] as? [String: Any] {
            for (_, userDict) in followedByDict {
                if let userDict = userDict as? [String: Any] {
                    self.followedBy.append(User(dictionary: userDict))
                }
            }
        }
        
        
    }
    
    // MARK: - HELPER METHODS
    func save(completion: @escaping (Error?) -> Void) {
        // 1
        let ref = DatabaseReference.users(uid: uid).reference()
        ref.setValue(toDictionary())
        
        // 2 - save follows
        for followUser in follows {
            ref.child("follows/\(followUser.uid)").setValue(followUser.toDictionary())
        }
        
        // 3 - save followed by
        for followedUser in followedBy {
            ref.child("followedBy/\(followedUser.uid)").setValue(followedUser.toDictionary())
        }
        
        // 4 - save the profile image
        
        if let profileImage = self.profileImage {
            let firImage = FIRImage(image: profileImage)
            
            firImage.saveProfileImage(self.uid, { (error) in
                
                completion(error)
                
            })
        }
    }
    
    
    func toDictionary() -> [String: Any] {
        return [
            "uid":      uid,
            "username": username,
            "fullName": fullName,
            "bio":      bio,
            "website":  website
        ]
    }
}


// MARK: - SHARE, DOWNLOAD AVATAR, FOLLOW METHODS
extension User {
    
    func share(newMedia: Media) {
        DatabaseReference.users(uid: uid).reference().child("media").childByAutoId().setValue(newMedia.uid)
    }
    
    
    func downloadProfilePicture(completion: @escaping (UIImage?, NSError?) -> Void) {
        FIRImage.downloadProfileImage(uid, completion: { (image, error) in
            
            self.profileImage = image
            
            completion(image, error as NSError?)
        })
    }
    
    func follow(user: User) {
        self.follows.append(user)
        let ref = DatabaseReference.users(uid: uid).reference().child("follows/\(user.uid)")
        ref.setValue(user.toDictionary())
    }
    
    
    func isFollowedBy(user: User) {
        self.followedBy.append(user)
        let ref = DatabaseReference.users(uid: uid).reference().child("followedBy/\(user.uid)")
        ref.setValue(user.toDictionary())
    }
}

// MARK: - CHAT METHODS

extension User {
    
    func saveNewChat(_ chat: Chat) {
        
        DatabaseReference.users(uid: self.uid).reference().child("chatIds/\(chat.uid)").setValue(true)
        
    }
    
    
}





// COMPARE METHOD (FOR "CONTAINS" FEATURE) - for checking if array constains current User

extension User: Equatable { }

func ==(lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}









