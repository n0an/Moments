//
//  ProfileViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 10/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase
import SAMCache

class ProfileViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func clearAllViewControllersWithLogout() {
        
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        let newsFeedNavVC = tabBarController.viewControllers?[0] as! UINavigationController
        let newsFeedVC = newsFeedNavVC.topViewController as! NewsfeedTableViewController
        
        let recentChatsNavVC = tabBarController.viewControllers?[2] as! UINavigationController
        let recentChatsVC = recentChatsNavVC.topViewController as! RecentChatsViewController
        
        newsFeedVC.userSignedOut()
        recentChatsVC.userSignedOut()
        
        SAMCache.shared().removeAllObjects()
        
        
    }
    
    @IBAction func actionLogOutDidTap(_ sender: Any) {
        
        try! FIRAuth.auth()?.signOut()
        
        self.clearAllViewControllersWithLogout()
        
        self.tabBarController?.selectedIndex = 0
        
        
    }

}
