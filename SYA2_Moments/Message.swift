//
//  Message.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 18/01/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

// MARK: - MessageType
public struct MessageType {
    static let text = "text"
    static let image = "image"
    static let video = "video"
}


class Message {
    
    // MARK: - PROPERTIES
    
    var ref: FIRDatabaseReference
    var uid: String
    
    var senderDisplayName: String
    var senderUID: String
    
    var lastUpdate: Date
    
    var type: String
    
    var text: String
    
    
    // MARK: - INITIALIZERS
    init(senderUID: String, senderDisplayName: String, type: String, text: String) {
        self.ref = DatabaseReference.messages.reference().childByAutoId()
        self.uid = ref.key
        
        self.senderDisplayName = senderDisplayName
        self.senderUID = senderUID
        
        self.type = type
        
        self.text = text
        
        self.lastUpdate = Date()
        
    }
    
    init(dictionary: [String: Any]) {
        self.uid                = dictionary["uid"] as! String
        self.ref                = DatabaseReference.messages.reference().child(self.uid)
        
        self.senderDisplayName  = dictionary["senderDisplayName"] as! String
        self.senderUID          = dictionary["senderUID"] as! String
        
        let lastUpdateTimeIntervalSince1970 = dictionary["lastUpdate"] as! TimeInterval
        self.lastUpdate         = Date(timeIntervalSince1970: lastUpdateTimeIntervalSince1970)
        
        self.type               = dictionary["type"] as! String
        self.text               = dictionary["text"] as! String
        
    }
    
    
    
    
    // MARK: - SAVE METHODS
    
    func save() {
        self.ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid"                   :   uid,
            "senderDisplayName"     :   senderDisplayName,
            "senderUID"             :   senderUID,
            "lastUpdate"            :   lastUpdate.timeIntervalSince1970,
            "type"                  :   type,
            "text"                  :   text
        ]
    }
    
    
}


// MARK: - Equatable
extension Message: Equatable { }

func ==(lhs: Message, rhs: Message) -> Bool {
    return lhs.uid == rhs.uid
}

















