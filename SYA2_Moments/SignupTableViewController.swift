//
//  SignupTableViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 08/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class SignupTableViewController: UITableViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - PROPERTIES
    var imagePickerHelper: ImagePickerHelper!
    var profileImage: UIImage!

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Create New Account"
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        profileImageView.layer.masksToBounds = true
        
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    // MARK: - HELPER METHODS
    func showAlert(withMessage message: String) {
        let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        self.present(errorAlert, animated: true, completion: nil)

    }
    

    // MARK: - ACTIONS
    @IBAction func actionCreateNewAccountButtonTapped() {
        // create a new account
        // save the user data, take photo
        // login the user
        
        guard emailTextField.text != "" else {
            showAlert(withMessage: "Enter your email")
            return
        }
        guard (userNameTextField.text?.characters.count)! > 6 else {
            showAlert(withMessage: "Username should contain 7 or more characters")
            return
        }
        guard (passwordTextField.text?.characters.count)! > 6 else {
            showAlert(withMessage: "Password should contain 7 or more characters")
            return
        }
        guard fullNameTextField.text != "" else {
            showAlert(withMessage: "Enter full name")
            return
        }
        guard profileImage != nil else {
            showAlert(withMessage: "Choose profile image")
            return
        }

        
        let username = userNameTextField.text!
        let fullName = fullNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firUser, error) in
            if error != nil {
                // report error
                self.showAlert(withMessage: "\(error?.localizedDescription)")
                
            } else if let firUser = firUser {
                
                let newUser = User(uid: firUser.uid, username: username, fullName: fullName, bio: "", website: "", follows: [], followedBy: [], profileImage: self.profileImage)
                newUser.save(completion: { (error) in
                    
                    if error != nil {
                        // report error
                        self.showAlert(withMessage: "\(error?.localizedDescription)")
                        
                    } else {
                        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                            if let error = error {
                                // report error
                                self.showAlert(withMessage: "\(error.localizedDescription)")
                            } else {
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                    
                })
            }
        })
        

        
    }
    
    @IBAction func actionBackTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func actionChangeProfilePhotoDidTap() {
        
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image
        })
        
    }
}


// MARK: - UITextFieldDelegate
extension SignupTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            userNameTextField.becomeFirstResponder()
        } else if textField == userNameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            
            
            actionCreateNewAccountButtonTapped()
        }
        
        return true
        
    }
    
    
}









