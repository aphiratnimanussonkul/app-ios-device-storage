
import UIKit

class KeyChainViewController: UIViewController, UITableViewDataSource {

    @IBAction func addButtonTapped(_ sender: Any) {
        showTextEntryAlert()
    }
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getUsernames().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let usernames = self.getUsernames()
        cell.textLabel?.text = usernames[indexPath.row]
        return cell
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
        let tag = "com.example.keys.mykey".data(using: .utf8)!
        let getquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecReturnAttributes as String: true,
            kSecReturnRef as String: true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getquery as CFDictionary, &item)
        guard status == errSecSuccess else {
            print("Can not Get data \(status)")
            return []
        }
        guard let extractItem = item as? [String : Any],
            let usernames = extractItem[kSecValueData as String] as? Data
            else {
                print("Can not extract Data")
                return []
        }
        
        var usernameDecode: Any?
        do {
            usernameDecode = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSArray.self], from: usernames)
        } catch {
            print("Can not decode Data")
        }
        return usernameDecode as! [String]
    }
    
    func setUsernames(usernames: [String]) {
        var usernameEncode: Data?
        do {
            usernameEncode = try NSKeyedArchiver.archivedData(withRootObject: usernames, requiringSecureCoding: false)
        } catch {
            print("Can not Encode Data")
            return
        }
        
        let tag = "com.example.keys.mykey".data(using: .utf8)!
        let addquery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: tag,
            kSecValueData as String: usernameEncode!
        ]

        let status = SecItemAdd(addquery as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            let keychainQuery: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrApplicationTag as String: tag,
            ]
            let updateStatus = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueData: usernameEncode] as CFDictionary)
            guard updateStatus == errSecSuccess else {
                print("cannot update \(updateStatus)")
                return
            }
            return
        }
    }

}
