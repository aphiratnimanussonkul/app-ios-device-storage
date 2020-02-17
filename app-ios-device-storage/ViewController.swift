//
//  ViewController.swift
//  app-ios-device-storage
//
//  Created by ODDS on 17/2/2563 BE.
//  Copyright © 2563 ODDS. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    var usernameTextField: UITextField!
    @IBAction func addButtonTapped(_ sender: Any) {
        showTextEntryAlert()
        print(usernameTextField.text!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        guard let data = UserDefaults.standard.object(forKey: "username1") else {
            return cell
        }
        cell.textLabel?.text = data as! String
        return cell
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
            self.usernameTextField = textField
            self.usernameTextField.delegate = self
            self.usernameTextField.placeholder = "Username"
        }
        
        
        let cencelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) {
            _ in
        }
        
        let otherAction = UIAlertAction(title: otherButtonTitle, style: .default, handler: {
            [weak self] _ in
            self?.usernameTextField.text = alertController.textFields![0].text
            UserDefaults.standard.set(self?.usernameTextField.text, forKey: "username1")
            self?.tableView.reloadData()
        })
        
        alertController.addAction(cencelAction)
        alertController.addAction(otherAction)
        
        present(alertController, animated: true, completion:  nil)
        
    }

}

