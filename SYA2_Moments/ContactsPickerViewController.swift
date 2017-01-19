//
//  ContactsPickerViewController.swift
//  SYA2_Moments
//
//  Created by Anton Novoselov on 19/01/2017.
//  Copyright © 2017 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase
import VENTokenField

class ContactsPickerViewController: UITableViewController {
    
    
    struct Storyboard {
        static let contactCell = "ContactCell"
    }

    // MARK: - OUTLETS
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var contactsPickerField: VENTokenField!
    
    // MARK: - PROPERTIES
    
    var chats: [Chat]!
    
    var accounts = [User]()
    var currentUser: User!
    
    var selectedAccounts = [User]()
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Message"

        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Setting currentUser
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // TODO: - try this, or appDelegate.window!.rootViewController
        let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        
        let firstNavVC = tabBarController.viewControllers?.first as! UINavigationController
        
        let newsFeedTVC = firstNavVC.topViewController as! NewsfeedTableViewController
        
        self.currentUser = newsFeedTVC.currentUser
        
        
        // Setting Contacts Picker Field
        
        contactsPickerField.placeholderText = "Search ..."
        contactsPickerField.setColorScheme(UIColor.red)
        contactsPickerField.delimiters = [",", ";", "--"]
        contactsPickerField.toLabelTextColor = UIColor.black
        
        contactsPickerField.dataSource = self
        contactsPickerField.delegate = self
        
        
        self.fetchUsers()
    }
    
    
    
    // MARK: - HELPER METHODS
    
    
    
    func fetchUsers() {
        
        let accountsRef = DatabaseReference.users(uid: currentUser.uid).reference().child("follows")
        
        accountsRef.observe(.childAdded, with: { (snapshot) in
            
            let user = User(dictionary: snapshot.value as! [String: Any])
            
            self.accounts.insert(user, at: 0)
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            // !!!IMPORTANT!!!
            self.tableView.insertRows(at: [indexPath], with: .fade)
            
        })
        
    }
    
    
    
    
    
    
    
    
    
    func addRecipient(account: User) {
        self.selectedAccounts.append(account)
        self.contactsPickerField.reloadData()
    }
    
    func deleteRecipient(account: User, index: Int) {
        self.selectedAccounts.remove(at: index)
        self.contactsPickerField.reloadData()
    }
    
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.contactCell, for: indexPath) as! ContactTableViewCell
        
        let contact = accounts[indexPath.row]
        
        cell.user = contact
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
        
        // toggle checkbox
        cell.added = !cell.added
        
        // Check after toggling checkbox (if added was false, now it is true, and we have to add recipient)
        
        if cell.added == true {
            self.addRecipient(account: cell.user)
        } else {
            if let index = selectedAccounts.index(of: cell.user) {
                self.deleteRecipient(account: cell.user, index: index)
            }
        }
        
        
    }
    
    
}

// MARK: - VENTokenFieldDataSource
extension ContactsPickerViewController: VENTokenFieldDataSource {
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(selectedAccounts.count)
    }
    
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        
        return selectedAccounts[Int(index)].fullName
        
    }
    
    
}


// MARK: - VENTokenFieldDelegate
extension ContactsPickerViewController: VENTokenFieldDelegate {
    
    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
        
        
        
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        
        let indexPath = IndexPath(row: Int(index), section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
        
        // toggle checkbox
        cell.added = !cell.added
        
        self.deleteRecipient(account: cell.user, index: Int(index))
        
    }
    
    
    
    
}






























