//
//  FirebaseReference.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 08/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase


enum DatabaseReference {
    
    case root
    case users(uid: String)
    case media                  // posts
    case chats
    case messages
    
    private var rootRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    private var path: String {
        
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users /\(uid)"
        case .media:
            return "media"
        case .chats:
            return "chats"
        case .messages:
            return "messages"
            
        }
    }
    
    // MARK: - Database Public API
    
    func reference() -> FIRDatabaseReference {
        return rootRef.child(path)
    }

}

enum StorageReference {
    
    case root
    case images         // for post
    case profileImages  // for user
    
    private var baseRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    private var path: String {
        
        switch self {
        case .root:
            return ""
        case .images:
            return "images"
        case .profileImages:
            return "profileImages"
            
        }
    }
    
    // MARK: - Storage Public API

    func reference() -> FIRStorageReference {
        return baseRef.child(path)
    }
    
}














