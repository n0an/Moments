//
//  Comment.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 17/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    
    // MARK: - PROPERTIES
    var mediaUID: String
    var uid: String
    
    var createdTime: Double!
    var from: User
    
    var caption: String
    var ref: FIRDatabaseReference
    
    // MARK: - INITIALIZERS
    init(mediaUID: String, from: User, caption: String) {
        self.mediaUID = mediaUID
        self.from = from
        self.caption = caption
        
        //        self.createdTime = Date().timeIntervalSince1970
        
        ref = DatabaseReference.media.reference().child("\(mediaUID)/comments").childByAutoId()
        
        uid = ref.key
    }
    
    
    init(dictionary: [String: Any]) {
        
        uid = dictionary["uid"] as! String
        mediaUID = dictionary["mediaUID"] as! String
        //        createdTime = dictionary["createdTime"] as! Double
        caption = dictionary["caption"] as! String
        
        let userDict = dictionary["from"] as! [String: Any]
        from = User(dictionary: userDict)
        
        
        ref = DatabaseReference.media.reference().child("\(mediaUID)/comments/\(uid)")
        
    }
    
    // MARK: - SAVE METHODS
    func save() {
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String: Any] {
        
        return [
            "mediaUID":     mediaUID,
            "uid":          uid,
            //            "createdTime":  createdTime,
            "createdTime": FIRServerValue.timestamp(),
            "from":         from.toDictionary(),
            "caption":      caption
            
        ]
        
        
    }
    
}

// MARK: - Equatable
extension Comment: Equatable { }

func ==(lhs: Comment, rhs: Comment) -> Bool {
    return lhs.uid == rhs.uid
}











