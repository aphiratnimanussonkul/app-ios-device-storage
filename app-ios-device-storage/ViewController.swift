//
//  ViewController.swift
//  app-ios-device-storage
//
//  Created by ODDS on 17/2/2563 BE.
//  Copyright © 2563 ODDS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButtonTapped(_ sender: Any) {
        showTextEntryAlert()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getUsernames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let usernames = getUsernames()
        cell.textLabel?.text = usernames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var usernames = getUsernames()
            usernames.remove(at: indexPath.row)
            UserDefaults.standard.set(usernames, forKey: "usernameArray")
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func showTextEntryAlert() {
        let title = NSLocalizedString("Add User", comment: "")
        let message = NSLocalizedString("Enter username that you want to add", comment: "")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "")
        let otherButtonTitle = NSLocalizedString("Save", comment: "")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addTextField {
            (textField) -> Void in
            textField.placeholder = "Username"
        }
        
        
        let cencelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) {
            _ in
        }
        
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .default, handler: {
            [weak self] _ in
            guard let username = alertController.textFields![0].text else {
                return
            }
            
            var usernames = self!.getUsernames()
            usernames.append(username)
            UserDefaults.standard.set(usernames, forKey: "usernameArray")
            self?.tableView.reloadData()
        })
        
        alertController.addAction(cencelAction)
        alertController.addAction(otherAction)
        
        present(alertController, animated: true, completion:  nil)
        
    }
    
    func getUsernames() -> [String] {
        guard let usernames = UserDefaults.standard.object(forKey: "usernameArray") as! [String]? else {
            return []
        }
        return usernames
    }

}

