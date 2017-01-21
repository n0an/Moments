//
//  ChatViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 19/01/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

/*
 
 1 - Send a text message - locally
 2 - Save message to Firebase
 3 - Download and observe messages
 4 - Fetch messages to ChatVC
 
 */

class ChatViewController: JSQMessagesViewController {
    
    // MARK: - PROPERTIES
    var chat: Chat!
    var currentUser: User!
    
    var messagesRef = DatabaseReference.messages.reference()
    var messages = [Message]()
    
    var jsqMessages = [JSQMessage]()
    
    
    var outgouingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        title = chat.title
        self.setupBubbleImages()
        self.setupAvatarImages()
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icon-back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(actionBackButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
        
        self.observeMessages()
    }
    
    
    // MARK: - BUBBLES FOR MESSAGES
    func setupBubbleImages() {
        
        let factory = JSQMessagesBubbleImageFactory()
        
        self.outgouingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        
        self.incomingBubbleImageView = factory?.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        
    }
    
    // MARK: - AVATAR IMAGES
    func setupAvatarImages() {
        
        // TODO: Download avatars from FIRStorage, and use them in this method
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
    }
    
    
    // MARK: - HELPER METHODS
    
    private func observeMessages() {
        
        let chatMessageIdsRef = chat.ref.child("messageIds")
        chatMessageIdsRef.observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.value as! String
            
            DatabaseReference.messages.reference().child(messageId).observe(.value, with: { (snapshot) in
                
                let message = Message(dictionary: snapshot.value as! [String: Any])
                
                self.messages.append(message)
                
                self.addMessages(message)
                
                self.finishReceivingMessage()
                
            })
            
        })
        
    }
    
    func addMessages(_ message: Message) {
        
        if message.type == MessageType.text {
            let jsqMessage = JSQMessage(senderId: message.senderUID, displayName: message.senderDisplayName, text: message.text)
            
            jsqMessages.append(jsqMessage!)
        }
        
    }
    
    
    
    // MARK: - ACTIONS
    
    func actionBackButtonTapped() {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
    

    

}

// MARK: - JSQMessagesCollectionViewDataSource
extension ChatViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return jsqMessages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return jsqMessages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            // OUTGOING MESSAGE WHITE TEXT
            cell.textView.textColor = UIColor.white
        } else {
            // INCOMING MESSAGE BLACK TEXT
            cell.textView.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    // *** CONFIGURING BUBBLE IMAGES FOR OUTGOING IN INCOMING
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let jsqMessage = jsqMessages[indexPath.item]
        
        if jsqMessage.senderId == self.senderId {
            return self.outgouingBubbleImageView
        } else {
            return self.incomingBubbleImageView
        }
        
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        // TODO: Download avatars from FIRStorage, and use them in this method
        return nil
        
        
    }
    
}

// MARK: - SEND MESSAGES
extension ChatViewController {
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        // If this is the first message in the chat - SAVE NEW CHAT
        
        if self.chat.messageIds.count == 0 {
            self.chat.save()
            
            for account in chat.users {
                account.saveNewChat(chat)
            }
            
        }
        
        let newMessage = Message(senderUID: currentUser.uid, senderDisplayName: currentUser.fullName, type: MessageType.text, text: text)
        
        newMessage.save()
        
        chat.send(message: newMessage)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
    }
    
    
    
    
}































