import UIKit

class CoreDataViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
            self?.setUsernames(usernames: usernames)
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
    
    func setUsernames(usernames: [String]) {
        UserDefaults.standard.set(usernames, forKey: "usernameArray")
    }
}
