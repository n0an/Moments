//
//  NewsfeedTableViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 08/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

public struct Storyboard {
    static let showWelcome = "ShowWelcomeViewController"
    static let postComposerNVC = "PostComposerNavigationVC"
    
    static let mediaCell = "MediaCell"
    static let mediaHeaderCell = "MediaHeaderCell"
    
    static let mediaHeaderHeight: CGFloat = 57
    static let mediaCellDefaultHeight: CGFloat = 597
    
    static let showMediaDetailSegue = "ShowMediaDetailSegue"
    
    static let commentCell = "CommentCell"
    static let showCommentComposer = "ShowCommentComposer"
}

class NewsfeedTableViewController: UITableViewController {
    
    // MARK: - PROPERTIES
    var imagePickerHelper: ImagePickerHelper!
    var currentUser: User?
    var medias = [Media]()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // check if the user logged in or not
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // signed in
                
                DatabaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        self.currentUser = User(dictionary: userDict)
                        print("===NAG===: currentUser = \(self.currentUser?.username)")
                        
                        self.fetchMedia()
                    }
                })
            } else {
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })
        
        self.tabBarController?.delegate = self
        
        tableView.estimatedRowHeight = Storyboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.separatorColor = UIColor.clear
        
    }
    
    
    // MARK: - HELPER METHODS
    func fetchMedia() {
        
        Media.observeNewMedia { (media) in
    
            if !self.medias.contains(media) {
                self.medias.insert(media, at: 0)
                self.tableView.reloadData()
            }
        }
        
    }
    
    func userSignedOut() {
        self.currentUser = nil
        self.medias.removeAll()
        self.tableView.reloadData()
        
        
    }

    
    
    // NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Storyboard.showMediaDetailSegue {
            
            if let selectedMedia = sender as? Media {
                let destinationVC = segue.destination as! MediaDetailTableViewController
                destinationVC.media = selectedMedia
                destinationVC.currentUser = currentUser
            }
            
        } else if segue.identifier == Storyboard.showCommentComposer {
            
            if let selectedMedia = sender as? Media {
                
                let destinationVC = segue.destination as! CommentComposerViewController
                destinationVC.currentUser = currentUser
                destinationVC.media = selectedMedia
            }
            
        }
        
        
    }
    
    
}


// MARK: - UITableViewDataSource

extension NewsfeedTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return medias.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if medias.count == 0 {
            return 0
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaTableViewCell
        
        cell.currentUser = currentUser
        
        cell.media = medias[indexPath.section]
        
        cell.selectionStyle = .none
        
        cell.delegate = self
        
        return cell
    }
    
    
    
}

// MARK: - UITableViewDelegate

extension NewsfeedTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedMedia = medias[indexPath.section]
        
        performSegue(withIdentifier: Storyboard.showMediaDetailSegue, sender: selectedMedia)
        
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = medias[section]
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }
}




// MARK: - UITabBarControllerDelegate

extension NewsfeedTableViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let _ = viewController as? DummyPostComposerViewController {
            
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                
                let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.postComposerNVC) as! UINavigationController
                
                let postComposerVC = postComposerNVC.topViewController as! PostComposerViewController
                
                postComposerVC.image = image
                
                self.present(postComposerNVC, animated: true, completion: nil)
                
            })
            
            return false
        }
        
        return true
        
    }
    
}


// MARK: - === MediaTableViewCellDelegate ===

extension NewsfeedTableViewController: MediaTableViewCellDelegate {
    
    func composeCommentButtonDidTapOnMedia(media: Media) {
        self.performSegue(withIdentifier: Storyboard.showCommentComposer, sender: media)
    }
}















