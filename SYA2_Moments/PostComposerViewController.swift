//
//  PostComposerViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 11/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit

class PostComposerViewController: UITableViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    // MARK: - PROPERTIES
    var image: UIImage!
    var imagePickerSourceType: UIImagePickerControllerSourceType!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.becomeFirstResponder()
        textView.text = ""
        textView.delegate = self
        
        shareBarButtonItem.isEnabled = false
        imageView.image = self.image
        
        tableView.allowsSelection = false
        
    }
    
    // MARK: - HELPER METHODS
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }


    
    // MARK: - ACTIONS
    @IBAction func cancelDidTap() {
        
        self.image = nil
        self.imageView.image = nil
        textView.resignFirstResponder()
        textView.text = ""
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func shareDidTap(_ sender: Any) {
        
        if let image = image, let caption = textView.text {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let tabBarController = appDelegate.window?.rootViewController as! UITabBarController
            let firstNavVC = tabBarController.viewControllers!.first as! UINavigationController
            let newsfeedTVC = firstNavVC.topViewController as! NewsfeedTableViewController
            
            if let currentUser = newsfeedTVC.currentUser {
                
                let newMedia = Media(type: "image", caption: caption, createdBy: currentUser, image: image)
                
                newMedia.save(completion: { (error) in
                    
                    if let error = error {
                        self.showAlert(title: "Oops!", message: error.localizedDescription, buttonTitle: "OK")
                    } else {
                        currentUser.share(newMedia: newMedia)
                    }
                })
            }
        }
        
        self.cancelDidTap()
    }
    
    
    
}


// MARK: - UITextViewDelegate
extension PostComposerViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        shareBarButtonItem.isEnabled = textView.text != ""
        
        
    }
    
}






























