//
//  WelcomeViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 08/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                
                self.dismiss(animated: false, completion: nil)
            } else {
                
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
