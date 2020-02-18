import UIKit
import CoreData

class CoreDataViewController: UIViewController, UITableViewDataSource {
    @IBAction func addButtonTapped(_ sender: Any) {
        showTextEntryAlert()
    }
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getUsers()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.getUsers()?[indexPath.row].name
        return cell
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            var usernames = getUsernames()
//            usernames.remove(at: indexPath.row)
//            setUsernames(usernames: usernames)
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let usernames = getUsers() else {
                return
            }
            deleteUser(user: usernames[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
            
            self?.setUser(username: username)
            self?.tableView.reloadData()
        })
        
        alertController.addAction(cencelAction)
        alertController.addAction(otherAction)
        
        present(alertController, animated: true, completion:  nil)
        
    }
    
    func getUsers() -> [User]? {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            do {
                let users = try context.fetch(fetchRequest) as? [User]
                return users
            } catch {
                return nil
            }
        }
        return nil
    }
    
    func setUser(username: String) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
            user.name = username
            do {
                try context.save()
            } catch  {
                print(error)
            }
        }
    }
    
    func deleteUser(user: User) {
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            context.delete(user)
        }
    }
}
