//
//  LoginViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 10/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UITableViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Login to Moments"
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: - HELPER METHODS
    func showAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }

    
    // MARK: - ACTIONS
    @IBAction func actionLoginDIdTap() {
        
        if emailTextField.text != "" && (passwordTextField.text?.characters.count)! > 6 {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                if let error = error {
                    self.showAlert(title: "Oops!", message: error.localizedDescription, buttonTitle: "OK")
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    
    @IBAction func actionBackDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            textField.resignFirstResponder()
            actionLoginDIdTap()
        } else {
            passwordTextField.becomeFirstResponder()
        }
        
        return true
    }
    
    
}

















