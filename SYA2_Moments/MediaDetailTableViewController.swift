//
//  MediaDetailTableViewController.swift
//  SYA2_Moments
//
//  Created by nag on 17/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class MediaDetailTableViewController: UITableViewController {

    // MARK: - PROPERTIES
    var media: Media!
    var currentUser: User!
    var comments = [Comment]()
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Media"
        
        tableView.allowsSelection = false
        
        tableView.estimatedRowHeight = Storyboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        comments = media.comments
        tableView.reloadData()
        
        self.fetchComments()
    }
    
    // MARK: - HELPER METHODS
    func fetchComments() {
        media.observeNewComment { (comment) in
            if !self.comments.contains(comment) {
                self.comments.insert(comment, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - ACTIONS
    @IBAction func commentDidTap() {
        self.performSegue(withIdentifier: Storyboard.showCommentComposer, sender: media)
    }
    
    // MARK: - NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showCommentComposer {
            let commentComposer = segue.destination as! CommentComposerViewController
            
            commentComposer.media = media
            commentComposer.currentUser = currentUser
        }
    }

  
    // MARK: - UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            let mediaCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaTableViewCell
            
            mediaCell.currentUser = currentUser
            
            mediaCell.media = media
            
            return mediaCell
            
        } else {
            let commentCell = tableView.dequeueReusableCell(withIdentifier: Storyboard.commentCell, for: indexPath) as! CommentTableViewCell
            
            commentCell.comment = comments[indexPath.row - 1]
            
            return commentCell
        }
        
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = self.media
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }

}























