//
//  Chat.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 18/01/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase


class Chat {
    
    // MARK: - PROPERTIES
    var uid: String
    var ref: FIRDatabaseReference
    
    var users: [User]
    
    var lastMessage: String
    var lastUpdate: Double
    
    var messageIds: [String]
    
    var title: String
    
    var featuredImageUID: String
    
    
    // MARK: - INITIALIZERS
    init(users: [User], title: String, featuredImageUID: String) {
        
        self.ref = DatabaseReference.chats.reference().childByAutoId()
        self.uid = ref.key
        
        self.users = users
        
        self.lastMessage = ""
        self.lastUpdate = Date().timeIntervalSince1970
        
        self.messageIds = []
        
        self.title = title
        
        self.featuredImageUID = featuredImageUID
        
    }
    
    init(dictionary: [String: Any]) {
        
        self.uid = dictionary["uid"] as! String
        self.ref = DatabaseReference.chats.reference().child(self.uid)
        
        self.lastMessage = dictionary["lastMessage"] as! String
        self.lastUpdate = dictionary["lastUpdate"] as! Double
        
        self.title = dictionary["title"] as! String
        
        self.featuredImageUID = dictionary["featuredImageUID"] as! String
        
        
        // initializing users
        self.users = []
        
        if let usersDict = dictionary["users"] as? [String: Any] {
            for user in usersDict.values {
                if let user = user as? [String: Any] {
                    self.users.append(User(dictionary: user))
                }
            }
        }
        
        // initializing messageIds
        self.messageIds = []
        
        if let messageIdsDict = dictionary["messageIds"] as? [String: Any] {
            for message in messageIdsDict.values {
                if let message = message as? String {
                    self.messageIds.append(message)
                }
            }
        }
        

    }
    
    // MARK: - SAVE METHODS
    func save() {
        
        self.ref.setValue(toDictionary())
        
        // saving users
        let usersRef = self.ref.child("users")
        
        for user in self.users {
            usersRef.child(user.uid).setValue(user.toDictionary())
        }
        
        // saving messages
        let messageIDsRef = ref.child("messageIds")
        
        for messageId in self.messageIds {
            messageIDsRef.childByAutoId().setValue(messageId)
        }
        
    }
    
    
    func toDictionary() -> [String : Any] {
        
        return [
            "uid"               :   uid,
            "lastMessage"       :   lastMessage,
            "lastUpdate"        :   lastUpdate,
            "title"             :   title,
            "featuredImageUID"  :   featuredImageUID
            
        ]
        
        
    }
    
    
    
    
}

extension Chat {
    
    // MARK: - DOWNLOAD IMAGE
    func downloadFeaturedImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadProfileImage(self.featuredImageUID) { (image, error) in
            
            completion(image, error)
            
        }
        
    }
    
    // MARK: - SEND MESSAGE
    func send(message: Message) {
        
        self.messageIds.append(message.uid)
        
        self.lastMessage = message.text
        
        self.lastUpdate = Date().timeIntervalSince1970
        
        // Partially saving when sending message (to not upload over all messages again)
        self.ref.child("lastUpdate").setValue(self.lastUpdate)
        self.ref.child("lastMessage").setValue(self.lastMessage)
        self.ref.child("messageIds").childByAutoId().setValue(message.uid)
    }
    
    
}

// MARK: - Equatable
extension Chat: Equatable { }

func ==(lhs: Chat, rhs: Chat) -> Bool {
    return lhs.uid == rhs.uid
}









































